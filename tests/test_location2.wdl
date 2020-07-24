version 1.0

workflow test_location {
    input {
        String docker = "replace this"
        String modules = "default_modules"
    }

    call find_tools as one {input: modules = modules,
        dockerrr = "x"}  

    call find_tools as two {input:
        modules = modules,
        dockerrr = "x"}

    call find_tools as three {
        input: modules = modules,
            dockerrr = "x"}

    call find_tools as four {
        input:
            modules = modules,
            dockerrr = "x"}

    call find_tools as five {input: 
        dockerrr = "c"}

    call find_tools as six {
        input: dockerrr = "c"} 

    call task2

    call task2 as dup1 {input: var1 = "var1 here"}

    call task2 as dup2 {input: var2 = "var2 here"}

    parameter_meta {
        docker: "fake docker param meta"
        modules: "required modules"
    }
}

task find_tools {
    input {
        String dockerrr = "comment out later"
        String modules = "fasplit/1.0 vep-hg19-filter-somaticsites/0 rsem/1.3.0 tabix/1.9"
    }
    command <<<
        echo "test \t"
        echo $FASPLIT_ROOT
        echo "@@@@@@@@@@@@@@@@"
        echo $TABIX_ROOT
        echo "@@@@@@@@@@@@@@@@"
        echo $RSEM_ROOT
        echo "@@@@@@@@@@@@@@@@"
        echo $VEP_HG19_FILTER_SOMATICSITES_ROOT
        echo "@@@@@@@@@@@@@@@@"
    >>>

    parameter_meta {
        modules: "required modules"
        docker: "fake docker param meta"
    }

    output {
        String message = read_string(stdout())
    }

    runtime {
        dockerrr: "g3chen/wgspipeline@sha256:3c0c292c460c8db19b9744be1ea81529c4d189e4c4f9ca9a63046edcf792087d"
        fast_docker: "replace"
    }
}

task task2 {
    input {
        String var1 = "default task2_var1"
        String var2 = "default task2_var2"
    }

    command <<<
        echo "task2 print out"
    >>>

    output {
        String task2Output = read_string(stdout())
    }
}
