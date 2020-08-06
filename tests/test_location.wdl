version 1.0
workflow test_location {
    input {
        Boolean yes = true
        Array[String]? inputString
    }

    if (yes) {
        call task1
    }

    if (!yes) {
        call task2
    }

    Array[String] selectInputString = select_all(inputString)

#    String out = if yes then task1.message else inputString
#    String out = select_first([task1.message, task2.message])
    String out = select_first([task1.message, selectInputString[0]])

    output {
        String out1 = out
    }
}

task task1 {
    command {
        echo "command output for yes"
    }

    output {
        #Array[String] message = ["output for yes", "also output for yes"]
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
