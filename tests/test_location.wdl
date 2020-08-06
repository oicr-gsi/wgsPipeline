version 1.0
workflow test_location {
    input {
        Boolean yes = true
    }

    if (yes) {
        call find_tools
    }

#    String out = if yes then find_tools.message else "nope"
    String out = select_first([find_tools.message, "nope"])

    output {
        String out1 = out
    }
}

task find_tools {
    command {
        echo "output for yes"
    }

    output {
        String message = read_string(stdout())
    }
}
