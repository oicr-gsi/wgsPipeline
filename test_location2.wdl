version 1.0

workflow test_location {
    call find_tools
}

task find_tools {
#    input {
#        String modules = "fasplit/1.0 vep-hg19-filter-somaticsites/0 rsem/1.3.0 tabix/1.9"
#    }
    command <<<
        ls $FASPLIT_ROOT
        echo "@@@@@@@@@@@@@@@@"
        ls $TABIX_ROOT
        echo "@@@@@@@@@@@@@@@@"
        ls $RSEM_ROOT
        echo "@@@@@@@@@@@@@@@@"
        ls $VEP_HG19_FILTER_SOMATICSITES_ROOT
        echo "@@@@@@@@@@@@@@@@"
    >>>
    output {
        String message = read_string(stdout())
    }
#    runtime {
#        docker: "g3chen/wgspipeline@sha256:3c0c292c460c8db19b9744be1ea81529c4d189e4c4f9ca9a63046edcf792087d"
#    }
}

# docker_volume: "/home/ubuntu/data/data_modules:/data_modules"