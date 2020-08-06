version 1.0
workflow test_location {
    input {
        Boolean yes = true
        String? inputString
    }

    if (yes) {
        call task1
    }

    if (!yes) {
        call task2
    }

#    String out = if yes then task1.message else inputString
#    String out = select_first([task1.message, task2.message])
    String out = select_first([task1.message, inputString])

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
