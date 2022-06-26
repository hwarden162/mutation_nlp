Identifying Gene Characteristics From Literature Using Machine Learning
================

This is a repository for a personal project to explore natural language
processing techniques. I am trying to use articles from the MEDLINE
database to identify characteristics about genes. This includes trying
to find words that are associated with different genes and different
types of genes. As well as (hopefully!) training an NLP based model that
can take a gene and determine what type it is.

## Blog Posts

A complete explanation of all the methods and decisions made can be
found in my blog posts

-   1)  [Data
        Collection](https://www.hwarden.com/project/mutation-nlp/identifying-gene-characteristics-from-literature-using-machine-learning-data-collection/)

## Contact and Contribution

This project was written by Hugh Warden, feel free to reach out to me
via:

-   Website: [hwarden.com](www.hwarden.com)
-   E-Mail: <hugh.warden@outlook.com>
-   Twitter: [HughWarden1](https://twitter.com/HughWarden1)
-   GitHub: [hwarden162](https://github.com/hwarden162)
-   LinkedIn: [Hugh
    Warden](https://www.linkedin.com/in/hugh-warden-b95049197/)

Please do get in touch with any suggestions!

## Session Information

Here is the session information for the R parts of the project.
Information on the Python modules can be found in the `environment.yml`
file.

    ## R version 4.1.2 (2021-11-01)
    ## Platform: x86_64-apple-darwin17.0 (64-bit)
    ## Running under: macOS Big Sur 10.16
    ## 
    ## Matrix products: default
    ## BLAS:   /Library/Frameworks/R.framework/Versions/4.1/Resources/lib/libRblas.0.dylib
    ## LAPACK: /Library/Frameworks/R.framework/Versions/4.1/Resources/lib/libRlapack.dylib
    ## 
    ## locale:
    ## [1] en_GB.UTF-8/en_GB.UTF-8/en_GB.UTF-8/C/en_GB.UTF-8/en_GB.UTF-8
    ## 
    ## attached base packages:
    ## [1] stats     graphics  grDevices utils     datasets  methods   base     
    ## 
    ## other attached packages:
    ##  [1] tidytext_0.3.3  forcats_0.5.1   stringr_1.4.0   dplyr_1.0.7    
    ##  [5] purrr_0.3.4     readr_2.1.1     tidyr_1.1.4     tibble_3.1.6   
    ##  [9] ggplot2_3.3.6   tidyverse_1.3.1
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] tidyselect_1.1.1  xfun_0.29         lattice_0.20-45   haven_2.4.3      
    ##  [5] colorspace_2.0-3  vctrs_0.3.8       generics_0.1.1    SnowballC_0.7.0  
    ##  [9] htmltools_0.5.2   yaml_2.2.2        utf8_1.2.2        rlang_1.0.2      
    ## [13] pillar_1.7.0      withr_2.5.0       glue_1.6.2        DBI_1.1.2        
    ## [17] dbplyr_2.1.1      modelr_0.1.8      readxl_1.3.1      lifecycle_1.0.1  
    ## [21] munsell_0.5.0     gtable_0.3.0      cellranger_1.1.0  rvest_1.0.2      
    ## [25] evaluate_0.14     knitr_1.37        tzdb_0.2.0        fastmap_1.1.0    
    ## [29] fansi_1.0.2       tokenizers_0.2.1  broom_0.7.11      Rcpp_1.0.8.3     
    ## [33] backports_1.4.1   scales_1.1.1      jsonlite_1.7.3    fs_1.5.2         
    ## [37] hms_1.1.1         digest_0.6.29     stringi_1.7.6     grid_4.1.2       
    ## [41] cli_3.2.0         tools_4.1.2       magrittr_2.0.2    janeaustenr_0.1.5
    ## [45] crayon_1.5.0      pkgconfig_2.0.3   Matrix_1.4-0      ellipsis_0.3.2   
    ## [49] xml2_1.3.3        reprex_2.0.1      lubridate_1.8.0   assertthat_0.2.1 
    ## [53] rmarkdown_2.11    httr_1.4.2        rstudioapi_0.13   R6_2.5.1         
    ## [57] compiler_4.1.2
