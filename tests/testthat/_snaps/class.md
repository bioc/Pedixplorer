# Class ped work

    Code
      ped2
    Output
      Ped object with 2 individuals and 0 metadata columns:
                         id       dadid       momid       famid       sex fertility
      col_class <character> <character> <character> <character> <ordered>  <factor>
      ID5               ID5        <NA>        <NA>        <NA>    female   fertile
      ID4               ID4        <NA>        <NA>        <NA>      male   fertile
                miscarriage  deceased     avail evaluated consultand   proband
      col_class    <factor> <logical> <logical> <logical>  <logical> <logical>
      ID5             FALSE      <NA>      <NA>     FALSE      FALSE     FALSE
      ID4             FALSE      <NA>      <NA>     FALSE      FALSE     FALSE
                 affected   carrier asymptomatic   adopted dateofbirth dateofdeath
      col_class <logical> <logical>    <logical> <logical> <character> <character>
      ID5            <NA>      <NA>         <NA>      <NA>        <NA>        <NA>
      ID4            <NA>      <NA>         <NA>      <NA>        <NA>        <NA>
                   useful       kin     isinf num_child_tot num_child_dir
      col_class <logical> <numeric> <logical>     <numeric>     <numeric>
      ID5            <NA>      <NA>      <NA>             0             0
      ID4            <NA>      <NA>      <NA>             0             0
                num_child_ind
      col_class     <numeric>
      ID5                   0
      ID4                   0

# Rel class works

    Code
      rel2
    Output
      Rel object with 2 relationshipswith 1 MZ twin, 0 DZ twin, 0 UZ twin, 1 Spouse:
                id1         id2                     code       famid |         A
        <character> <character> <c("ordered", "factor")> <character> | <numeric>
      1         ID3         ID5                  MZ twin        <NA> |         1
      2         ID2         ID4                   Spouse        <NA> |         2

# Hints class works

    Code
      hts0
    Output
      An object of class "Hints"
      Slot "horder":
      ID1 ID2 ID3 ID4 
        1   2   3   4 
      
      Slot "spouse":
        idl idr anchor
      1 ID1 ID3   left
      2 ID2 ID4  right
      

# Scales class works

    invalid class "Scales" object: 1: Fill slot affected column(s) must be logical
    invalid class "Scales" object: 2: Fill slot angle, order, mods column(s) must be numeric
    invalid class "Scales" object: 3: Fill slot column_mods column(s) must be character

---

    invalid class "Scales" object: 1: Border slot labels column(s) must be character
    invalid class "Scales" object: 2: Border slot mods column(s) must be numeric

---

    Code
      scl0
    Output
      An object of class "Scales"
      Slot "fill":
        order column_values column_mods mods labels affected fill density angle
      1     2           ID1         ID1    1    ID1     TRUE  ID3       1    90
      2     3           ID2         ID2    2    ID2    FALSE  ID2       2    60
      
      Slot "border":
        column_values column_mods mods labels border
      1           ID1         ID1    1   Lab1    ID1
      2           ID2         ID2    2   Lab2    ID2
      

