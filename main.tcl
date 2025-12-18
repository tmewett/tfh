package require Tk

oo::class create app {
    variable iDir
    variable viewingDir
    constructor {} {
        grid [ttk::button .up -text "Up" -command "[self] upClicked"]
        grid [ttk::frame .files]
        set iDir [pwd]
        set viewingDir ""
    }
    method itemClicked {path} {
        puts $path
    }
    method upClicked {} {
        set iDir [file dirname $iDir]
        my update
    }
    method update {} {
        if {$iDir != $viewingDir} {
            cd $iDir
            set files [glob *]
            foreach child [winfo children .files] {
                destroy $child
            }
            set i 0
            foreach file $files {
                grid [ttk::label .files.$i -text $file]
                incr i
            }
            set $viewingDir $iDir
        }
    }
}

set appO [app new]
$appO update

tkwait window .
