% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/enrichR_functions.R
\name{test_gsea}
\alias{test_gsea}
\title{Gene Set Enrichment Analysis}
\usage{
test_gsea(dep, databases = c("GO_Molecular_Function_2017b",
  "GO_Cellular_Component_2017b", "GO_Biological_Process_2017b"),
  contrasts = TRUE)
}
\arguments{
\item{dep}{SummarizedExperiment,
Data object for which differentially enriched proteins are annotated
(output from \code{\link{test_diff}()} and \code{\link{add_rejections}()}).}

\item{databases}{Character,
Databases to search for gene set enrichment.
See http://amp.pharm.mssm.edu/Enrichr/ for available databases.}

\item{contrasts}{Logical(1),
Whether or not to perform the gene set enrichment analysis
independently for the different contrasts.}
}
\value{
A data.frame with enrichment terms (generated by \code{\link[enrichR]{enrichr}})
}
\description{
\code{test_gsea} tests for enriched gene sets
in the differentially enriched proteins.
This can be done independently for the different contrasts.
}
\examples{
# Load example
data <- UbiLength
data <- data[data$Reverse != "+" & data$Potential.contaminant != "+",]
data_unique <- make_unique(data, "Gene.names", "Protein.IDs", delim = ";")

# Make SummarizedExperiment
columns <- grep("LFQ.", colnames(data_unique))
exp_design <- UbiLength_ExpDesign
se <- make_se(data_unique, columns, exp_design)

# Filter, normalize and impute missing values
filt <- filter_missval(se, thr = 0)
norm <- normalize_vsn(filt)
imputed <- impute(norm, fun = "MinProb", q = 0.01)

# Test for differentially expressed proteins
diff <- diff <- test_diff(imputed, "control", "Ctrl")
dep <- add_rejections(diff, alpha = 0.05, lfc = 1)

\dontrun{

# Test enrichments
gsea_results_per_contrast <- test_gsea(dep)
gsea_results <- test_gsea(dep, contrasts = FALSE)

gsea_kegg <- test_gsea(dep, databases = "KEGG_2016")

}
}
