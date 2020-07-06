workflow test_location {
    call find_tools
}

task find_tools {
    command {
#        ls $STAR_FUSION_ROOT
#        echo "@@@@@@@@@@@@@@@@"
        ls $PERL_ROOT
        echo "@@@@@@@@@@@@@@@@"
        ls $STAR_ROOT
        echo "@@@@@@@@@@@@@@@@"
        ls $SAMTOOLS_ROOT
        echo "@@@@@@@@@@@@@@@@"
        ls $HTSLIB_ROOT
        echo "@@@@@@@@@@@@@@@@"
#        ls $BAM_QC_METRICS_ROOT
#        echo "@@@@@@@@@@@@@@@@"
        ls $VCF2MAF_ROOT
        echo "@@@@@@@@@@@@@@@@"
#        ls $SEQUENZA_RES_ROOT
#        echo "@@@@@@@@@@@@@@@@"
#        ls $BARCODEX_ROOT
#        echo "@@@@@@@@@@@@@@@@"

        echo $PATH
        echo "################"
        echo $MANPATH
        echo "################"
        echo $LD_LIBRARY_PATH
        echo "################"
        echo $PERL5LIB
        echo "################"
        echo $PKG_CONFIG_PATH
        echo "################"
    }
    output{
        String message = read_string(stdout())
    }
    runtime {
        docker: "g3chen/wgspipeline@sha256:05d3b337cdb4bfd413d9835c6f8b1989bcdf9ef4227b8bff2cb738492a835580"
        modules: "vcf2maf/1.6.17"
    }
}
