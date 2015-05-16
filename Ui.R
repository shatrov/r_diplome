
library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title = "Header",
                  dropdownMenu(type = "messages",
                               messageItem(
                                 from = "Sales Dept",
                                 message = "Sales are steady this month."
                               ),
                               messageItem(
                                 from = "New User",
                                 message = "How do I register?",
                                 icon = icon("question"),
                                 time = "13:45"
                               ),
                               messageItem(
                                 from = "Support",
                                 message = "The new server is ready.",
                                 icon = icon("life-ring"),
                                 time = "2014-12-01"
                               )
                  )),
  dashboardSidebar(
    sidebarSearchForm(textId = "searchText", buttonId = "searchButton",
                      label = "Год,Группа,Студент"),
    sidebarMenu(
            menuItem("Information",tabName ="dashboard",icon = icon("dashboard")),
            menuItem("Факультеты",tabName ="fac_main",icon = icon("th"))
      )
    
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "dashboard",
                box(tableOutput("table"))

              ),
      
  
      tabItem(tabName = "fac_main",
              box(
                wellPanel(
                  uiOutput("ui_facultet"),
                  uiOutput("ui_section")
                          )
                )
              ,box(
                  verbatimTextOutput("summary")
                )
              
      )
    )
  )  
    
)   



