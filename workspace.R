library(tercen)
library(dplyr)

options("tercen.workflowId" = "0add2df8c4543198d0b9ab7b55003e76")
options("tercen.stepId"     = "7f6e198c-24c3-4ff1-b136-269cb60a085d")

doc_to_data = function(df){
  filename = tempfile()
  writeBin(ctx$client$fileService$download(df$documentId[1]), filename)
  on.exit(unlink(filename))
  
  dat <- readLines(filename)
  first.lines <- grep(">", dat)
  seqs <- list()
  first.lines <- c(first.lines, length(dat) + 1)
  for(i in 1:(length(first.lines) - 1)) {
    seq <- dat[first.lines[i]:(first.lines[i+1] - 1)]
    df_tmp <- c(name = seq[1], letter = paste(seq[-1], sep="", collapse=""))
    df_tmp_out <- data.frame(
      name = df_tmp[["name"]],
      letter = strsplit(df_tmp["letter"], "")
    ) %>% mutate(position = 1:nrow(.))
    seqs[[i]] <- df_tmp_out
  }
  
  df_out <- as.data.frame(do.call(rbind, seqs)) %>%
    mutate(value = as.numeric(as.factor(letter))) %>%
    mutate(.ci= rep_len(df$.ci[1], nrow(.)))
  
  return(df_out)
}

ctx <- tercenCtx()

if (!any(ctx$cnames == "documentId")) stop("Column factor documentId is required") 

df <- ctx$cselect() %>% 
  mutate(.ci= 1:nrow(.)-1L) %>%
  split(.$.ci) %>%
  lapply(doc_to_data) %>%
  bind_rows() %>%
  ctx$addNamespace() %>%
  ctx$save()
