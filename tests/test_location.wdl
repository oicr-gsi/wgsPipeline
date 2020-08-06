workflow test_location {
    input {
        Boolean yes = true
    }

    if (yes) {
        call find_tools
    }

    String out = if yes then find_tools.message else "nope"

    output {
        String out1 = out
    }
}

task find_tools {
    command {
        echo "output for yes"
    }

    output{
        String message = read_string(stdout())
    }
}
