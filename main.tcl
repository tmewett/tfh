package require Tk

oo::class create app {
    constructor {} {
        grid [ttk::treeview .tree]
        .tree insert {} end -text "Hello"
    }
}

set appO [app new]

tkwait window .
