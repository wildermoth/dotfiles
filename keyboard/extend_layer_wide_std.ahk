#SingleInstance, Force

#InstallKeybdHook
#KeyHistory

#InputLevel 1
CapsLock::F24
#InputLevel 0

#Persistent
SetCapsLockState, AlwaysOff

; digit row
F24 & SC001::return ; Esc
F24 & SC029::Reload ; `
F24 & SC002::Send {Blind}{CtrlDown}{ShiftDown}{AltDown}{1}{AltUp}{ShiftUp}{CtrlUp} ; 1
F24 & SC003::Send {Blind}{CtrlDown}{ShiftDown}{AltDown}{2}{AltUp}{ShiftUp}{CtrlUp} ; 2
F24 & SC004::Send {Blind}{CtrlDown}{ShiftDown}{AltDown}{3}{AltUp}{ShiftUp}{CtrlUp} ; 3
F24 & SC005::Send {Blind}{CtrlDown}{ShiftDown}{AltDown}{4}{AltUp}{ShiftUp}{CtrlUp} ; 4
F24 & SC006::Send {Blind}{CtrlDown}{ShiftDown}{AltDown}{5}{AltUp}{ShiftUp}{CtrlUp} ; 5
F24 & SC007::Send {Blind}{CtrlDown}{ShiftDown}{AltDown}{6}{AltUp}{ShiftUp}{CtrlUp} ; 6
F24 & SC008::Send {Blind}{CtrlDown}{ShiftDown}{AltDown}{7}{AltUp}{ShiftUp}{CtrlUp} ; =
F24 & SC009::Send {Blind}{7} ; 7
F24 & SC00A::Send {Blind}{8} ; 8
F24 & SC00B::Send {Blind}{9} ; 9
F24 & SC00C::Send {Blind}{0} ; 0
F24 & SC00D::Send {Blind}{-} ; -

; top row
F24 & SC010::SetCapsLockState, % GetKeyState("CapsLock", "T") ? "AlwaysOff" : "On" ; Q - Toggle CapsLock state
F24 & SC011::Media_Play_Pause  ; W
F24 & SC012::Send {CtrlDown}{f}{CtrlUp} ; F
F24 & SC013::Send {Blind}{LWinDown}{ShiftDown}{s}{ShiftUp}{LWinUp} ; P
F24 & SC014::Send {Blind}{CtrlDown}{p}{CtrlUp} ; B
F24 & SC015::return ; [
F24 & SC016::Send {Blind}{PgUp} ; J
F24 & SC017::Send {Blind}{Home} ; L
F24 & SC018::Send {Blind}{Up} ; U
F24 & SC019::Send {Blind}{End} ; Y
F24 & SC01A::Send {Blind}{Delete} ; ;
F24 & SC02B::Send {Blind}{|} ; \


; middle row
F24 & SC01E::Send {Blind}{LWinDown} ; A down
F24 & SC01F::Send {Blind}{CtrlDown} ; R down
F24 & SC020::Send {Blind}{ShiftDown} ; S down
F24 & SC021::Send {Blind}{CtrlDown} ; T down
F24 & SC022::Send {Blind}{AltDown} ; G down 
F24 & SC023::return ; ]
F24 & SC024::Send {Blind}{PgDn} ; M
F24 & SC025::Send {Blind}{Left} ; N
F24 & SC026::Send {Blind}{Down} ; E
F24 & SC027::Send {Blind}{Right} ; I
F24 & SC028::Send {Blind}{Backspace} ; O

; Modifier release
F24 & SC01E up::Send {Blind}{LWinUp} ; A up
F24 & SC01F up::Send {Blind}{CtrlUp} ; R up
F24 & SC020 up::Send {Blind}{ShiftUp} ; S up
F24 & SC021 up::Send {Blind}{CtrlUp} ; T up
F24 & SC022 up::Send {Blind}{AltUp} ; G up

; bottom row
F24 & SC02C::Send {Blind}{CtrlDown}{x}{CtrlUp} ; X
F24 & SC02D::Send {Blind}{CtrlDown}{c}{CtrlUp} ; C
F24 & SC02E::Send {Blind}{CtrlDown}{s}{CtrlUp} ; D
F24 & SC02F::Send {Blind}{CtrlDown}{v}{CtrlUp} ; V
F24 & SC030::Send {Blind}{CtrlDown}{z}{CtrlUp} ; Z
F24 & SC031::Send {Blind}{CtrlDown}{l}{CtrlUp} ; /
F24 & SC032::Send {Blind}{PrintScreen} ; K
F24 & SC033::Send {Blind}{Backspace} ; H
F24 & SC034::Send {Blind}{Tab} ; ,
F24 & SC035::Send {AppsKey} ; .
F24 & SC039::Send {Blind}{CtrlDown}{ShiftDown}{p}{ShiftUp}{CtrlUp} ; Space

; RAlt handler
RAlt::GetKeyState, cp, CapsLock, T | if navLayer | navLayer := 0 | else if cp = D | SetCapsLockState, AlwaysOff
