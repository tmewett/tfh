package require Tk

oo::class create app {
    variable iDir
    variable viewingDir
    constructor {} {
        grid [ttk::button .up -text "Up" -command "[self] upClicked"]
        grid [ttk::frame .files -width 640 -height 480]
        grid [ttk::scrollbar .filesScroll -command [list .files yview]] -row 1 -column 1 -sticky ns
        grid propagate .files false
        set iDir [pwd]
        set viewingDir ""
    }
    method upClicked {} {
        set iDir [file dirname $iDir]
        my update
    }
    method dirClicked {path} {
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
            set entries [concat $dirs $files]
            set viewingEntries [lrange $entries 0 10]
            .filesScroll set 0 [expr 10. / [llength $entries]]
            set i 0
            foreach entry $viewingEntries {
                grid [ttk::label .files.$i -text $entry] -sticky w
                if [file isdirectory $entry] {
                    .files.$i configure -foreground "blue violet"
                    bind .files.$i <1> [list [self] dirClicked $entry]
                }
                incr i
            }
            set $viewingDir $iDir
        }
    }
}

set appO [app new]
$appO update

tkwait window .
