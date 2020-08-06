version 1.0
workflow test_location {
    input {
        Boolean yes = true
    }

    if (yes) {
        call task1
    }

    if (!yes) {
        call task2
    }

#    String out = if yes then find_tools.message else "nope"
    String out = select_first([task1.message, task2.message])

    output {
        String out1 = out
    }
}

task task1 {
    command {
        echo "output for yes"
    }

    output {
        String message = read_string(stdout())
    }
}

task task2 {
    command {
        echo "output for no"
    }

    output {
        String message = read_string(stdout())
    }
}
