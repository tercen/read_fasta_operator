library(tercen)
library(dplyr)

options("tercen.workflowId" = "a77770c3923fad0ca99b77fa8905471d")
options("tercen.stepId"     = "c5813823-50ed-4f7b-ac6c-262b0aeb103d")

doc_to_data = function(df){
  filename = tempfile()
  writeBin(ctx$client$fileService$download(df$documentId[1]), filename)
  on.exit(unlink(filename))
  
  dat <- readLines(filename)
  first.lines <- grep(">", dat)
  seqs <- list()
  for(i in 1:(length(first.lines) - 1)) {
    seq <- dat[first.lines[i]:(first.lines[i+1] - 1)]
    df_tmp <- c(name = seq[1], sequence = paste(seq[-1], sep="", collapse=""))
    seqs[[i]] <- df_tmp
  }
  
  df_out <- as.data.frame(do.call(rbind, seqs)) %>%
    mutate(.ci= rep_len(df$.ci[1], nrow(.)))
  return(df_out)
}

ctx = tercenCtx()

if (!any(ctx$cnames == "documentId")) stop("Column factor documentId is required") 

ctx$cselect() %>% 
  mutate(.ci= 1:nrow(.)-1) %>%
  split(.$.ci) %>%
  lapply(doc_to_data) %>%
  bind_rows() %>%
  ctx$addNamespace() %>%
  ctx$save()
