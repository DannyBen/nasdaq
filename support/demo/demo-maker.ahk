; --------------------------------------------------
; This script generates the demo gif
; NOTE: This should be executed in the root folder
; --------------------------------------------------
#SingleInstance Force
SetkeyDelay 0, 50

Return

Type(Command, Delay=2000) {
  Send % Command
  Sleep 500
  Send {Enter}
  Sleep Delay
}

F12::
  Type("{#} F11 aborts")
  Type("cd ./support/demo")
  Type("rm cast.json {;} asciinema rec cast.json")

  Type("nasdaq")
  Type("nasdaq --help")
  Type("nasdaq get datasets/WIKI/AAPL rows:5")
  Type("nasdaq get --csv datasets/WIKI/AAPL rows:5 column_index:4")
  Type("nasdaq see datasets/WIKI/AAPL rows:2 column_index:4")
  Type("nasdaq save out.csv --csv datasets/WIKI/AAPL rows:5 column_index:4")
  Type("cat out.csv")
  
  Type("exit")
  Type("agg --font-size 20 cast.json cast.gif")
  Sleep 400
  Type("cd ../../")
  Type("{#} Done")
Return

^F12::
  Reload
return

F11::
  ExitApp
return
