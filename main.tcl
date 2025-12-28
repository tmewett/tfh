package require Tk

oo::class create app {
    variable iDir viewDir viewStartL viewStart entries
    constructor {} {
        grid [ttk::button .up -text "Up" -command "[self] upClicked"]
        grid [ttk::frame .files -width 640 -height 480]
        bind .files <5> [list [self] scrolled 1]
        grid [ttk::scrollbar .filesScroll] -row 1 -column 1 -sticky ns
        grid propagate .files false
        set iDir [pwd]
        set viewDir ""
        set viewStart 0
        set viewStartL 0
    }
    method scrolled {delta} {
        my update [list scroll $delta]
    }
    method upClicked {} {
        set iDir [file dirname $iDir]
        my update {}
    }
    method dirClicked {path} {
        set iDir $iDir/$path
        my update {}
    }
    method update {eventsIn} {
        set events [dict merge {scroll 0} $eventsIn]
        set dirChanged [expr {$iDir != $viewDir}]
        if $dirChanged {
            cd $iDir
            set globList [glob *]
            set dirs [list]
            set files [list]
            foreach entry $globList {
                if [file isdirectory $entry] {
                    lappend dirs $entry
                } else {
                    lappend files $entry
                }
            }
            set entries [concat $dirs $files]
            .filesScroll set 0 [expr 16. / [llength $entries]]
            set viewDir $iDir
        }
        incr viewStart [dict get $events scroll]
        if {$dirChanged || $viewStart != $viewStartL} {
            foreach child [winfo children .files] {
                destroy $child
            }
            set viewingEntries [lrange $entries $viewStart [expr $viewStart +16]]
            set i 0
            foreach entry $viewingEntries {
                grid [ttk::label .files.$i -text $entry] -sticky w
                if [file isdirectory $entry] {
                    .files.$i configure -foreground "blue violet"
                    bind .files.$i <1> [list [self] dirClicked $entry]
                }
                incr i
            }
            set viewStartL $viewStart
        }
    }
}

set appO [app new]
$appO update {}

tkwait window .
