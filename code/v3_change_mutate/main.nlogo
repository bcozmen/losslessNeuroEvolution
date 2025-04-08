__includes ["nn.nls" "utils.nls" "behaviour/produce.nls" "behaviour/consume.nls"  "behaviour/move.nls" "behaviour/exchange.nls" "behaviour/utils.nls" "ga/ga.nls" "ga/genome.nls"]

extensions [csv]
breed [people person]


people-own[
  genome;
  genome-mut;
  age;
  charm;
  reputation;
  utility;

  produce-rate;

  inventory;
  max-trade-inventory;
  prices
  trade-wish;
  trade-wish-plot;
  tv-dist

  needs;

  mutated?
  reproduce?
  did-reproduce?
  number-of-childeren

  activation


  net-produce
  net-trade
  net-trade-volume
  net-consume
  family-color

]

patches-own[
  elevation;
  total-production-wish
]

globals[
  input-lengths
  output-lengths
  network-layers
  networks

  genome-length
  maximum-gene-bit
  gene-points


  start-inventory
  max-inventory
  start-needs
  min-needs
  max-needs


  gdp-per-capita
  production-per-capita
  consume-per-capita
  trade-per-capita

  plot-trade-wish-buy
  plot-trade-wish-sell
  plot-prices
  trade-count


  death-by-starvation
  death-by-age
  new-borns
  death-age

  season
  ;0 winter - 1 spring - 2 summer - 3 fall

  max-product
  season-efficiency-table
  good_table
  need_table
]



to setup-map
  ask patches[
   set elevation pxcor
    ifelse pxcor < max-pxcor * 0.33 [set pcolor scale-color yellow elevation -50 100]
    [set pcolor scale-color green elevation -0 120]

    set total-production-wish [0 0 0]
 ]
end

to reset-people
  ask people[
    set net-trade [0 0 0]
    set net-trade-volume [0 0 0]
    set did-reproduce? false
    set utility 0
  ]
end

to set-people-variables
  set needs max-needs
  set charm 0
  set reputation 0
  set utility 0
  set prices n-values (length inventory) [1]
  set trade-wish n-values (length inventory) [0]
  set tv-dist 1

  set number-of-childeren 0
  set reproduce? false
  set did-reproduce? false

  set net-produce n-values (length inventory) [0]
  set net-trade n-values (length inventory) [0]
  set net-trade-volume n-values (length inventory) [0]
  set net-consume n-values (length inventory) [0]
  set family-color color
end

to create-population [num]
  create-people num[
    set activation 0
    set shape "person"
    set size 2
    setxy random-xcor random-ycor

    set age random (max-age - (init-ticks) - 2)
    new-genome
    set inventory start-inventory
    set mutated? 0
    set-people-variables

  ]
end


to set-parameters
  set death-by-starvation 0
  set death-by-age 0
  set new-borns 0

  ;Genome parameters
  set-genome-basics

  ;Need and agent basics
  read-files
  set max-inventory [200 200 200]

  set start-inventory (map [[a] -> 20] max-inventory)
  set min-needs need_table
  set start-needs (map [[a] -> a * 2] min-needs)
  set max-needs (map [[a] -> a * 4] min-needs)
end

to setup
  clear-all
  reset-ticks

  set-parameters
  setup-map
  create-population initial-population


end



to redistribute
  let zakat (map [[a b] -> max (list 0 (a / 2))] inventory max-inventory)
  let reciever other people in-radius fog-radius
  let c-reciever count reciever
  if c-reciever > 0[
    ask reciever [
      set inventory (map [[a b] -> a + b / c-reciever] inventory zakat)
    ]
  ]
  set inventory (map - inventory zakat)
end



to reset-map
  ask patches[
    set total-production-wish [0.000001 0.000001 0.000001]
  ]
end

to new-tick-reset
  reset-map
  reset-people
  set trade-count 0
  if season = 0[
    set production-per-capita [0 0 0]
    set consume-per-capita [0 0 0]
    set trade-per-capita [0 0 0]

    set plot-trade-wish-buy [0 0 0]
    set plot-trade-wish-sell [0 0 0]
    set plot-prices [0 0 0]

    set death-by-starvation 0
    set death-by-age 0
    set new-borns 0
    set death-age []
  ]
end


to print-gdp
  let gdp [0 0 0]

  foreach [inventory] of people[i ->
   set gdp (map + gdp i)
  ]
  show "GDP"
  show gdp

end

to debug
  print-gdp
  check-minus-inv
end

to-report get-random-mate [pop cum-sum]
  let rnd random-float 1
  let ix 0

  foreach range (length pop)[ p-ix ->
    if item p-ix cum-sum > rnd[
      report p-ix
    ]
  ]
  report 0
end
to go



  set season (ticks mod 4)

  if count turtles = 0 [stop]
  create-population genetic-diversity-add

  new-tick-reset
  if debug?[debug show "produce"]

  ask people[
    calculate-produce-rate
  ]
  ask people[
   produce
  ]
  if debug?[debug show "exchange" ]

  if ticks >= init-ticks * 4[
    foreach range market-size[ix ->
      set trade-count ix
      ask people[
        get-prices
      ]

      foreach shuffle sort people[p ->
        ask p[exchange]
      ]
    ]
  ]

  if debug?[debug show "consume"]

  ask people[
   consume
  ]

  if debug?[debug show "check-reproduce" ]

  ask people[
        check-reproduce
  ]

  if debug?[debug show "move"]
  clear-drawing
  ask people[
    move
  ]

  if debug?[ debug show "mate"]

  if season = 1 and ticks >= init-ticks * 4 and false[
    foreach sort-by [ [a b] -> sum [needs] of a > sum [needs] of b ] people with [reproduce?][ p ->
      ask p [mate]
    ]
  ]

  if season = 1 and ticks >= init-ticks * 4[
    let pop (people with [reproduce?])
    let total-charm sum [charm] of pop
    set pop sort-by [[a b] -> [charm] of a > [charm] of b] pop

    let cum-sum []
    let sum-so-far 0
    foreach pop [ p ->
      set sum-so-far (sum-so-far + ([charm] of p) / total-charm)
      set cum-sum (lput sum-so-far cum-sum)
    ]

    foreach range (length pop)[
      let p-ix (get-random-mate pop cum-sum)
      ask item p-ix pop [mate]

    ]
  ]


  if debug? [debug]

  if (season = 0)[
    ask people[
      set age (age + 1)
    ]
  ]

  ;show (new-borns - death-by-age - death-by-starvation)

  ask people[
    set inventory (map [[a b] -> min (list b a)] inventory max-inventory)
    set inventory (map [[a] -> max (list 0 a)] inventory)
  ]




  if debug?[debug]

  if debug?[show "redistribute" debug]

  ask people[
   evaluate-survival
    if not (member? false (map [[n m] -> n > 3.5 * m ] needs min-needs))[
      set reputation (reputation + 1)
    ]
  ]
  if (season = 3 and ticks > (start-plot-year * 4))[
    plot-graphs
  ]
  check-switch
  if debug?[show "end" debug]
  tick



  if (ticks > (nm-tick-start - 1)) and nm-decrease? and (count turtles > nm-min-pop) and nutrition-multiplyer > nm-min [
   set nutrition-multiplyer (nutrition-multiplyer * nm-decay)
    read-files



  ]
  if ticks mod 500 = 0[
      save-checkpoint (word checkpoint-name "-" (precision nutrition-multiplyer 3) ".sav")
    ]



end
to info
  ask one-of turtles with [who = 203077][
   show net-consume
   show net-produce
   show inventory
    show age
  ]
end
to write-agent
  file-delete "../../output.txt"
  file-open "../../output.txt"
  ask one-of turtles[
    file-print (word activation "-" pxcor "-" pycor)
    show (word activation "-" pxcor "-" pycor)
    foreach range 4 [ix ->
     file-print cut-gene genome ix
    ]

  ]
  file-close
end
@#$#@#$#@
GRAPHICS-WINDOW
198
17
856
301
-1
-1
25.0
1
15
1
1
1
0
0
0
1
0
25
0
10
1
1
1
ticks
30.0

BUTTON
0
10
67
43
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
76
10
139
43
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
0
131
172
164
initial-population
initial-population
0
2000
1000.0
100
1
NIL
HORIZONTAL

SLIDER
0
402
172
435
mutation-chance
mutation-chance
0
1
0.3
0.1
1
NIL
HORIZONTAL

PLOT
1264
18
1579
168
population
Time
Pop
0.0
10.0
25.0
50.0
true
true
"" ""
PENS
"pop" 1.0 0 -7500403 true "" ""
"pr" 1.0 0 -2674135 true "" ""
"ex" 1.0 0 -15040220 true "" ""
"co" 1.0 0 -6459832 true "" ""
"mo" 1.0 0 -13345367 true "" ""

SLIDER
0
211
172
244
max-age
max-age
0
100
25.0
1
1
NIL
HORIZONTAL

BUTTON
44
89
107
122
NIL
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
1264
176
1581
326
death-birth
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"starve" 1.0 0 -16777216 true "" ""
"age" 1.0 0 -7500403 true "" ""
"new" 1.0 0 -2674135 true "" ""

PLOT
1594
18
1900
168
gdp-per-capita
NIL
NIL
0.0
10.0
0.0
1.0
true
true
"" ""
PENS
"Fish" 1.0 0 -16777216 true "" ""
"Wheat" 1.0 0 -7500403 true "" ""
"Meat" 1.0 0 -2674135 true "" ""

SLIDER
1
290
173
323
fertility-start
fertility-start
0
fertility-end
5.0
1
1
NIL
HORIZONTAL

SLIDER
1
327
173
360
fertility-end
fertility-end
0
max-age
25.0
1
1
NIL
HORIZONTAL

SLIDER
0
365
177
398
nutrition-multiplyer
nutrition-multiplyer
0
20
6.232964799437022
0.1
1
NIL
HORIZONTAL

PLOT
1595
168
1899
318
production-per-capita
NIL
NIL
0.0
10.0
0.0
1.0
true
true
"" ""
PENS
"Fish" 1.0 0 -16777216 true "" ""
"Wheat" 1.0 0 -7500403 true "" ""
"Meat" 1.0 0 -2674135 true "" ""

PLOT
1591
335
1898
485
trade-per-capita
NIL
NIL
0.0
1.0
0.0
0.1
true
true
"" ""
PENS
"Fish" 1.0 0 -16777216 true "" ""
"Wheat" 1.0 0 -7500403 true "" ""
"Meat" 1.0 0 -2674135 true "" ""

SLIDER
0
171
172
204
min-population
min-population
0
100
60.0
1
1
NIL
HORIZONTAL

BUTTON
20
52
120
85
NIL
clear-plots
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
1262
496
1583
646
num-child
NIL
NIL
0.0
40.0
0.0
10.0
true
false
"" ""
PENS
"avg" 1.0 0 -16777216 true "" ""

PLOT
1263
336
1583
486
avg-death-age
NIL
NIL
0.0
30.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" ""

SLIDER
0
252
188
285
genetic-diversity-add
genetic-diversity-add
0
100
0.0
5
1
NIL
HORIZONTAL

SLIDER
0
436
172
469
start-plot-year
start-plot-year
0
10
0.0
1
1
NIL
HORIZONTAL

PLOT
1941
21
2191
171
produce-weights
NIL
NIL
-5.0
5.0
0.0
10.0
true
false
"" ""
PENS
"0" 1.0 0 -16777216 true "" ""
"1" 1.0 0 -7500403 true "" ""
"2" 1.0 0 -2674135 true "" ""

PLOT
1939
195
2216
345
exchange-weights
NIL
NIL
-5.0
5.0
0.0
10.0
true
false
"" ""
PENS
"0" 1.0 0 -7500403 true "" ""
"1" 1.0 0 -2674135 true "" ""
"2" 1.0 0 -955883 true "" ""

PLOT
1940
383
2140
533
consume-weights
NIL
NIL
-5.0
5.0
0.0
10.0
true
false
"" ""
PENS
"0" 1.0 0 -7500403 true "" ""
"1" 1.0 0 -2674135 true "" ""
"2" 1.0 0 -955883 true "" ""

PLOT
1937
549
2137
699
move-weights
NIL
NIL
-5.0
5.0
0.0
10.0
true
false
"" ""
PENS
"0" 1.0 0 -7500403 true "" ""
"1" 1.0 0 -2674135 true "" ""
"2" 1.0 0 -955883 true "" ""

SLIDER
0
468
172
501
fog-radius
fog-radius
0
30
4.0
1
1
NIL
HORIZONTAL

PLOT
1595
493
1901
643
consume-per-capita
NIL
NIL
0.0
10.0
0.0
1.0
true
true
"" ""
PENS
"Fish" 1.0 0 -16777216 true "" ""
"Wheat" 1.0 0 -7500403 true "" ""
"Meat" 1.0 0 -2674135 true "" ""

CHOOSER
864
21
1029
66
show-agent-color
show-agent-color
"family" "charm" "activation" "satisfaction" "production" "consumption" "inventory" "net-trade-buy" "net-trade-sell" "trade-volume" "traded-item" "trade-wish-buy" "trade-wish-sell" "prices" "genome" "utility" "age" "num-child" "trade-will" "want-reproduce?" "reproduce?" "k-means"
14

BUTTON
862
78
975
111
NIL
check-switch
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
0
729
249
762
NIL
save-checkpoint checkpoint-name\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
0
765
247
798
NIL
load-checkpoint checkpoint-name\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

INPUTBOX
258
735
503
795
checkpoint-name
t4/1
1
0
String

OUTPUT
861
223
1252
394
12

SLIDER
962
555
1134
588
k-means-param
k-means-param
0
15
3.0
1
1
NIL
HORIZONTAL

SLIDER
12
572
184
605
market-size
market-size
0
50
10.0
5
1
NIL
HORIZONTAL

INPUTBOX
971
600
1132
660
who-number
-1.0
1
0
Number

CHOOSER
1060
20
1198
65
show-item1
show-item1
"Fish" "Wheat" "Meat"
0

SWITCH
865
170
1015
203
show-k-means
show-k-means
1
1
-1000

CHOOSER
1069
81
1207
126
show-item2
show-item2
"Fish" "Wheat" "Meat"
0

BUTTON
1072
170
1213
203
NIL
k-means-weights
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
16
623
188
656
init-ticks
init-ticks
0
20
2.0
1
1
NIL
HORIZONTAL

SWITCH
871
422
980
455
mutate?
mutate?
0
1
-1000

SWITCH
1025
421
1156
454
crossover?
crossover?
1
1
-1000

SLIDER
886
682
1058
715
pr-gaussian-a
pr-gaussian-a
0
1
0.4
0.05
1
NIL
HORIZONTAL

SLIDER
889
729
1061
762
pr-gaussian-b
pr-gaussian-b
0
1
0.3
0.05
1
NIL
HORIZONTAL

PLOT
1044
834
1244
984
pr-gaussian
NIL
NIL
0.0
10.0
0.0
1.0
true
false
"" ""
PENS
"0" 1.0 0 -16777216 true "" ""
"1" 1.0 0 -7500403 true "" ""
"2" 1.0 0 -2674135 true "" ""

BUTTON
892
779
1036
812
NIL
draw-pr-gaussian
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SWITCH
885
470
988
503
debug?
debug?
1
1
-1000

BUTTON
218
391
311
424
NIL
read-files\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
1283
822
1483
972
plot-activation
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"r" 1.0 0 -16777216 true "" ""
"s" 1.0 0 -7500403 true "" ""
"t" 1.0 0 -2674135 true "" ""

PLOT
1924
724
2124
874
prices
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"Fish" 1.0 0 -16777216 true "" ""
"Wheat" 1.0 0 -7500403 true "" ""
"Meat" 1.0 0 -2674135 true "" ""

SLIDER
870
127
1042
160
color-coeff
color-coeff
0
1
1.0
0.1
1
NIL
HORIZONTAL

CHOOSER
1094
477
1232
522
hidden-activation
hidden-activation
"relu" "sigmoid" "tanh"
0

PLOT
1262
650
1585
800
nutrition multiplier
NIL
NIL
0.0
10.0
0.0
1.0
true
false
"" ""
PENS
"NM" 1.0 0 -16777216 true "" "plot nutrition-multiplyer"

SWITCH
599
501
703
534
inherit?
inherit?
0
1
-1000

SLIDER
598
539
770
572
inheritence
inheritence
0
0.5
0.2
0.1
1
NIL
HORIZONTAL

BUTTON
331
395
450
428
save nutrition
save-checkpoint (word checkpoint-name \"-\" nutrition-multiplyer \".sav\")
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SWITCH
597
449
745
482
nm-decrease?
nm-decrease?
0
1
-1000

SLIDER
598
386
770
419
nm-min
nm-min
0
10
1.0
0.1
1
NIL
HORIZONTAL

SLIDER
601
338
773
371
nm-decay
nm-decay
0.9
1
0.999
0.00005
1
NIL
HORIZONTAL

INPUTBOX
342
327
503
387
nm-tick-start
50.0
1
0
Number

SLIDER
406
465
578
498
nm-min-pop
nm-min-pop
0
400
200.0
50
1
NIL
HORIZONTAL

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.4.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
