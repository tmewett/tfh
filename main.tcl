package require Tk

oo::class create app {
    variable iDir
    variable viewingDir
    constructor {} {
        grid [ttk::button .up -text "Up" -command "[self] upClicked"]
        grid [ttk::frame .files -width 640 -height 480]
        grid [ttk::scrollbar .filesScroll -command [list .files yview]] -column 1
        grid propagate .files false
        set iDir [pwd]
        set viewingDir ""
    }
    method upClicked {} {
        set iDir [file dirname $iDir]
        my update
    }
    method fileClicked {path} {
        set iDir $iDir/$path
        my update
    }
    method update {} {
        if {$iDir != $viewingDir} {
            cd $iDir
            set entries [glob *]
            foreach child [winfo children .files] {
                destroy $child
            }
            set dirs [list]
            set files [list]
            foreach entry $entries {
                if [file isdirectory $entry] {
                    lappend dirs $entry
                } else {
                    lappend files $entry
                }
            }
            set i 0
            foreach entry $dirs {
                grid [ttk::label .files.$i -text $entry/ -foreground "blue violet"] -sticky w
                bind .files.$i <1> [list [self] fileClicked $entry]
                incr i
            }
            foreach entry $files {
                grid [ttk::label .files.$i -text $entry] -sticky w
                bind .files.$i <1> [list [self] fileClicked $entry]
                incr i
            }
            set $viewingDir $iDir
        }
    }
}

set appO [app new]
$appO update

tkwait window .
