#All data sets
#dat<-read.csv("datasets.txt",header=FALSE,strip.white=TRUE,stringsAsFactors=FALSE)
#db<-as.list(dat$V1)
#names(db)<-dat$V2

#only a few data sets
db<-list("mtcars","iris","swiss","ChickWeight","faithful","sleep","InsectSprays","ToothGrowth")

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
      
      # Application title
      titlePanel("ezRegression"),
      
      # Sidebar with all the needed input
      sidebarLayout(
            sidebarPanel(
                  helpText("First choose the data set, next select 
                           the outcome variable, and finally check all 
                           the covariates you want to include in the model!"),
                  selectInput("db", label = h3("Select data set"), 
                              choices = db,selected="mtcars"),
                  uiOutput('outcomeselect'),
                  uiOutput('varselect'),
                  helpText("Or press the button below to use R's 'step' function 
                           to find the best model based on AIC"),
                  actionButton("dostep", label = "Find best model by the step function")
                  
            ),            
            # Show the results in the main panel
            mainPanel(
                  h4("The structure of the selected data set:"),
                  verbatimTextOutput("showdata"),
                  htmlOutput('help'),                  
                  h4("The current linear model:"),
                  textOutput("formula"),
                  h4("The best model found by you so far (based on AIC):"),
                  textOutput("bestmodel"),
                  h4("The best model found by R's 'step' function:"),
                  textOutput("stepmodel"),
                  br(),
                  h4("Summary of currently fitted Model"),
                  verbatimTextOutput("model"),
                  h4("Diagnostic Plots for the current Model"),
                  plotOutput("plot")                  
            )
      )
))
