#' @rdname plot_ped
#' @importFrom shiny NS tagList uiOutput checkboxInput
plot_ped_ui <- function(id) {
    ns <- shiny::NS(id)
    shiny::tagList(
        shiny::uiOutput(ns("computebig")),
        shiny::uiOutput(ns("plotpedi")),
        shiny::checkboxInput(
            ns("interactive"),
            label = "Make the pedigree interactive", value = FALSE
        )
    )
}

#' Shiny module to generate pedigree graph.
#'
#' This module allows to plot a pedigree object. The plot can be interactive.
#' The function is composed of two parts: the UI and the server.
#' The UI is called with the function `plot_ped_ui()` and the server
#' with the function `plot_ped_server()`.
#'
#' @param id A string.
#' @param pedi A reactive pedigree object.
#' @param title A string to name the plot.
#' @param precision An integer to set the precision of the plot.
#' @param max_ind An integer to set the maximum number of individuals to plot.
#' @param tips A character vector of the column names of the data frame to use
#' as tooltips. If NULL, no tooltips are added.
#' @param lwd A numeric to set the line width of the plot.
#' @returns A reactive ggplot or the pedigree object.
#' @examples
#' if (interactive()) {
#'     data("sampleped")
#'     pedi <- shiny::reactive({
#'         Pedigree(sampleped[sampleped$famid == "1", ])
#'     })
#'     plot_ped_demo(pedi)
#' }
#' @rdname plot_ped
#' @keywords internal
#' @importFrom shiny is.reactive NS moduleServer reactive renderUI req
#' @importFrom shiny tagList checkboxInput plotOutput
#' @importFrom ggplot2 scale_y_reverse theme element_blank
#' @importFrom plotly ggplotly renderPlotly plotlyOutput
#' @importFrom shinycssloaders withSpinner
plot_ped_server <- function(
    id, pedi, title = NA, precision = 2,
    max_ind = 500, tips = NULL, lwd = par("lwd")
) {
    stopifnot(shiny::is.reactive(pedi))
    shiny::moduleServer(id, function(input, output, session) {

        ns <- shiny::NS(id)

        mytips <- shiny::reactive({
            if (shiny::is.reactive(tips)) {
                tips <- tips()
            }
            tips
        })

        mytitle <- shiny::reactive({
            if (shiny::is.reactive(title)) {
                title <- title()
            }
            title
        })

        output$computebig <- shiny::renderUI({
            shiny::req(pedi())
            if (length(pedi()) > max_ind) {
                shiny::tagList(
                    shiny::checkboxInput(
                        ns("computebig"),
                        label = paste(
                            "There are too many individuals",
                            "to compute the plot.",
                            "Do you want to continue?"
                        ), value = FALSE
                    )
                )
            }
        })

        pedi_val <- shiny::reactive({
            shiny::req(pedi())
            if (length(pedi()) > max_ind) {
                if (is.null(input$computebig) || input$computebig == FALSE) {
                    return(NULL)
                }
            }
            pedi()
        })

        plotly_ped <- shiny::reactive({
            shiny::req(input$interactive)
            shiny::req(pedi_val())
            ped_plot_lst <- plot(
                pedi_val(),
                aff_mark = TRUE, label = NULL, ggplot_gen = input$interactive,
                cex = 1, symbolsize = 1, force = TRUE,
                ped_par = list(mar = c(0.5, 0.5, 1.5, 0.5)),
                title = mytitle(), tips = mytips(),
                precision = precision, lwd = lwd / 3
            )

            ggp <- ped_plot_lst$ggplot + ggplot2::scale_y_reverse() +
                ggplot2::theme(
                    panel.grid.major =  ggplot2::element_blank(),
                    panel.grid.minor =  ggplot2::element_blank(),
                    axis.title.x =  ggplot2::element_blank(),
                    axis.text.x =  ggplot2::element_blank(),
                    axis.ticks.x =  ggplot2::element_blank(),
                    axis.ticks.y =  ggplot2::element_blank(),
                    axis.title.y =  ggplot2::element_blank(),
                    axis.text.y =  ggplot2::element_blank()
                )
            ## To make it interactive
            plotly::ggplotly(
                ggp +
                    ggplot2::theme(legend.position = "none"),
                tooltip = "text"
            ) %>%
                plotly::layout(hoverlabel = list(bgcolor = "darkgrey"))
        })
        output$plotpedi <- shiny::renderUI({
            if (is.null(input$interactive)) {
                return(NULL)
            }
            if (input$interactive) {
                output$ped_plotly <- plotly::renderPlotly({
                    plotly_ped()
                })
                plotly::plotlyOutput(ns("ped_plotly"), height = "700px") %>%
                    shinycssloaders::withSpinner(color = "#8aca25")
            } else {
                output$ped_plot <- shiny::renderPlot({
                    shiny::req(pedi_val())
                    plot(
                        pedi_val(),
                        aff_mark = TRUE, label = NULL,
                        cex = 1, symbolsize = 1, force = TRUE,
                        ped_par = list(mar = c(0.5, 0.5, 2, 0.5)),
                        title = mytitle(),
                        precision = precision, lwd = lwd
                    )
                })
                shiny::plotOutput(ns("ped_plot"), height = "700px") %>%
                    shinycssloaders::withSpinner(color = "#8aca25")
            }
        })

        shiny::reactive({
            if (input$interactive) {
                plotly_ped()
            } else {
                pedi_val()
            }
        })
    })
}

#' @rdname plot_ped
#' @export
#' @importFrom shiny shinyApp fluidPage
plot_ped_demo <- function(
    pedi, precision = 2, max_ind = 500, tips = NULL
) {
    ui <- shiny::fluidPage(
        plot_ped_ui("plotped"),
        plot_download_ui("saveped")
    )

    server <- function(input, output, session) {
        ped_plot <- plot_ped_server(
            "plotped",
            pedi = pedi, tips = tips,
            title = "My Pedigree", max_ind = max_ind,
            precision = precision
        )
        plot_download_server("saveped", ped_plot)
    }
    shiny::shinyApp(ui, server)
}
