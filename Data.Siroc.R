Data.Siroc <- function(files,per_sem,inicio_sem,inicio_quin, patron = "Y0123456789", mov = 30 ) {
  
  #primero se extare el dato del período al que pertencen los recibos, ya sea semanal o quincenal
  
  per <- sapply(strsplit(sapply(strsplit(pdftools::pdf_text(files)," Periodo: +"), `[`, 2), "\r"), `[`, 1)
  per_Filt_1 <- trimws(per)
  per_Filt_2 <- as.numeric(per_Filt_1)
  per_F <- as.data.frame(per_Filt_2)
  
  
  #después se extrae el número de días que laboró cada trabajador
  
  dias <- sapply(strsplit(sapply(strsplit(pdftools::pdf_text(files), 
                                          "Días\\ trabajados:"
  ), `[`, 2), "\r"), `[`, 1)
  dias_Filt <- gsub("                                        ","", dias)
  dias_Filt_2 <- gsub("                                  ","", dias_Filt)
  dias_Filt_3 <- trimws(dias_Filt_2)
  dias_Filt_4 <- as.numeric(dias_Filt_3)
  dias_F <- as.data.frame(dias_Filt_4)
  
  #con base en las fechas de incio de semana y de quincena, se suman los días trabajados a la fecha de inicio 
  #de este modo se obtiene la fecha hasta la que el empleado trabajó en la semana
  inicio_sem_1 <- as.Date(inicio_sem, format = "%d/%m/%Y")
  inicio_quin_1 <- as.Date(inicio_quin, format = "%d/%m/%Y")
  
  
  inicio_F <- ifelse(per_sem == per_F,inicio_sem_1,inicio_quin_1)
  
  inicio_F <- as.Date(inicio_F,"1970-01-01")
  
  termino_F <- inicio_F + dias_Filt_4 - 1
  
  #las fechas de incio y término son converitdas de fecha a carácter y se les remueven los separadores
  # ejem. 10/10/2020 = 10102020
  
  inicio_c <- as.character(inicio_F)
  termino_c <- as.character(termino_F)
  
  dia_i <- substr(inicio_c,9,10)
  mes_i <- substr(inicio_c,6,7)
  anio_i <- substr(inicio_c,1,4)
  
  Fecha_i <- paste(dia_i,mes_i,anio_i,sep = "")
  #se crea data frame para su uso posterior en el objeto JUNTAR
  Fecha_i_frame <- as.data.frame(Fecha_i)
  
  dia_f <- substr(termino_c,9,10)
  mes_f <- substr(termino_c,6,7)
  anio_f <- substr(termino_c,1,4)
  
  Fecha_f <- paste(dia_f,mes_f,anio_f,sep = "") 
  #se crea data frame para su uso posterior en el objeto JUNTAR
  Fecha_f_frame <- as.data.frame(Fecha_f)
  
  #se extrae el nss de cada trabajador y se le quitan los separadores "-"
  
  nss <- sapply(strsplit(sapply(strsplit(pdftools::pdf_text(files), 
                                         "No\\. IMSS: +"), `[`, 2), "\r"), `[`, 1)
  nss_Filt <- gsub("-","", nss)
  nss_F <- as.character(nss_Filt)
  #se crea data frame para su uso posterior en el objeto JUNTAR
  nss_Frame <- as.data.frame(nss_F)
  
  #Se extrae la obra a la que pretenece cada trabajador del ramo "depto"
  
  OBRA <- sapply(strsplit(sapply(strsplit(pdftools::pdf_text(files),"Depto\\.: +"), `[`, 2), "\r"), `[`, 1)
  
  OBRA <- as.character(OBRA)
  
  #se subtraen los primeros cinco caracteres de cada obra y se compara con la lista "registros" la cual contiene
  #los primeros 5 carácteres de cada obra y su número de registro de SIROC. Por útlimo se reemplaza la obra con
  #el SIROC utilzando la función left_join
  
  OBRA <- substr(OBRA,1,5)
  
  OBRA <- as.data.frame(OBRA)
  
  library(readxl)
  registros <- read_excel("registros.xlsx")
  
  join_obra <- left_join(OBRA,registros)
  
  #se extrae únicamente la columna con el SIROC de la obra en la que está cada trabajador
  
  join_obra_s <- join_obra$siroc
  #se crea data frame para su uso posterior en el objeto JUNTAR
  obra_frame <- as.data.frame(join_obra_s)
  
  #el último paso es concatenar los criterios de  "patron", nss_Frame, mov,Fecha_i_frame, Fecha_frame y obra_frame, 
  #esto se hace con cbind y se guarda en el objeto JUNTAR, posteriormente na.omit se utiliza para descartar las obras que no tienen SIROC
  #en la misma cadena sin separadores. Para posteriormente ser convertido a un archivo txt que está listo
  #para su importación al SUA.
  
  JUNTAR <- cbind(patron,  nss_Frame,mov,Fecha_i_frame, Fecha_f_frame,obra_frame)
  JUNTAR_f <- na.omit(JUNTAR)
  
  txt <- paste(JUNTAR_f$patron,JUNTAR_f$nss_F,JUNTAR_f$mov,JUNTAR_f$Fecha_i,JUNTAR_f$Fecha_f,JUNTAR_f$join_obra_s,sep = "")
  
  write.table(txt, file = "SIROC.txt",row.names = FALSE,col.names = FALSE,quote = FALSE)
  
}

