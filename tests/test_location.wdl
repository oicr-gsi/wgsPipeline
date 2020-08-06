version 1.0
workflow test_location {
    input {
        Boolean yes = false
        Array[String]? inputStrings
        #String inputString = "output for no"
    }

    if (yes) {
        call task1
    }

#    if (!yes) {
#        call task2
#    }

#    Array[String] selectInputString = select_all(inputString)

#    Array[String] multiOut = if yes then task1.message else inputString
    Array[String] multiOut = select_first([task1.message, inputStrings])
#    String out = select_first(multiOut)

    output {
        #String out1 = out
        String out2 = multiOut[0]
    }
}

task task1 {
    command {
        echo "command output for yes"
    }

    output {
        Array[String] message = ["output for yes", "also output for yes"]
        #String message = read_string(stdout())
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
