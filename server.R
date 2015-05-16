library(ROracle)
library(xtable)
shinyServer(function(input, output){
  output$ui_facultet <- renderUI({
    drv <- dbDriver("Oracle")
    con <- dbConnect(drv, username = "ruser", password = "glm2704")
    #изменить только таблицу
    rs <- dbSendQuery(con, "SELECT * FROM r_facultet")
    data_fac <<- fetch(rs)
    short_utf_8<-data_fac$SHORTNAME
    data_fac$SHORTNAME<-iconv(data_fac$SHORTNAME,'utf8','windows-1251')
    k <- data_fac$SHORTNAME
    dbDisconnect(con)
    selectInput("fac", "Факультеты",as.list(k))
   
  })
  
  
  output$ui_section <- renderUI({
#     #изменить только таблицу
    drv <- dbDriver("Oracle")
    con <- dbConnect(drv, username = "ruser", password = "glm2704")
    #pk_fac <- 3
    data_fac$SHORTNAME <-iconv(data_fac$SHORTNAME,'utf8','windows-1251')
    length_fac <-length(data_fac$SHORTNAME)
    for (i in 1:length_fac) {
      if (data_fac$SHORTNAME[i] == input$fac)
      {pk_fac <<- data_fac$PK[i]} 
    }
    #pk_fac<-5
    sql <- paste("SELECT fo.name,fo.fsk_facultet,fo.pk  FROM r_facultet f join r_facultet_okso fo on fo.fsk_facultet = f.pk where f.pk=",pk_fac)
    rs <- dbSendQuery(con, sql) 
    data_fac_sec <<- fetch(rs)
    data_fac_sec$NAME <- iconv(data_fac_sec$NAME,'utf8','cp1251')
    k <- data_fac_sec$NAME
    dbDisconnect(con)
    selectInput("section", "Направление",as.list(k))
    
  })
  

  output$summary <- renderPrint({
    drv <- dbDriver("Oracle")
    con <- dbConnect(drv, username = "ruser", password = "glm2704")
    pk_fac_sec <- 0
    data_fac_sec$NAME <-iconv(data_fac_sec$NAME,'utf8','windows-1251')
    length_fac_sec <-length(data_fac_sec$NAME)
    for (i in 1:length_fac_sec) {
      if (data_fac_sec$NAME[i] == input$section & data_fac_sec$FSK_FACULTET[i]== pk_fac)
      {pk_fac_sec <- data_fac_sec$PK[i]} 
    }
    sql <- paste("SELECT d.EGE1,d.EGE2,d.EGE3,d.EGE4  FROM r_facultet_okso fo join r_data1 d on d.FK_FACULTET_OKSO = fo.PK where fo.PK =",pk_fac_sec)
    rs <- dbSendQuery(con, sql) 
    data_fac_sec_summ <- fetch(rs)
    #data_fac_sec_summ
    #data_fac_sec$NAME <- iconv(data_fac_sec$NAME,'utf8','cp1251')
    #k <- data_fac_sec$NAME
    dbDisconnect(con)
    ch <- rowMeans(data_fac_sec_summ)
    sch <- sum(ch,na.rm = T)
    if (sch > 0 )
      summary(data_fac_sec_summ)
    else
      print("Нет данных об этом направлении")
  })

      
      
      output$table <- renderTable({
        
         
          if (m <- nchar(input$searchText) == 0){
            k <- data.frame()
            k[1,1] <- "Введите данные в поисковую строку"
            k <- xtable(k)
            #k[1,1]
          }
          else{
            drv <- dbDriver("Oracle")
            con <- dbConnect(drv, username = "ruser", password = "glm2704")
            query <- paste("select year_abitura, id_student,ege1 from r_data1  where ID_STUDENT =",input$searchText, "or  FK_FACULTET_OKSO=",input$searchText,"or YEAR_ABITURA=",input$searchText )
            rs <- dbSendQuery(con, query)
            data_fac_osko <- fetch(rs)
            if (input$searchText >= 2011 && input$searchText <= 2041)
            {
              summary(data_fac_osko)
            }
            else
            {
              data_fac_osko
            }
            
          }

                      
        })
})
