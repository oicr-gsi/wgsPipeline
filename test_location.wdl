workflow test_location {
    call find_tools
}

task find_tools {
    command {
        ls $FASPLIT_ROOT
        echo "@@@@@@@@@@@@@@@@"
        ls $TABIX_ROOT
        echo "@@@@@@@@@@@@@@@@"
        ls $RSEM_ROOT
        echo "@@@@@@@@@@@@@@@@"
        ls $VEP_HG19_FILTER_SOMATICSITES_ROOT
        echo "@@@@@@@@@@@@@@@@"
    }
    output{
        String message = read_string(stdout())
    }
    runtime {
        docker: "g3chen/wgspipeline@sha256:c1a2f1842f5e51df5ac5b6cda552b6151f945fd9c6f8388135bf83095e65f57c"
        modules: "fasplit/1.0 vep-hg19-filter-somaticsites/0 rsem/1.3.0"
    }
}
