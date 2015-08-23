library(shiny)
library(datasets)


shinyServer(function(input, output) {
      best<-reactiveValues(model=NULL,aic=1e9,fml="NULL",run=FALSE)
      step<-reactiveValues(model=NULL,aic=1e9,fml="NULL",run=FALSE)

      mydata <- reactive({
            step$run <- FALSE
            best$run <- FALSE
            get(input$db)
            })
      fml<-reactive({
            paste(input$outcome," ~ ",
                             paste(input$vars,collapse=" + "),"+ 1")
            })      
      
      fitted<-reactive({
            model<-lm(as.formula(fml()),data=mydata())
            aic<-AIC(model)
            if (aic < best$aic || best$run==FALSE) 
            {
                  best$run<-TRUE
                  best$model<-model
                  best$aic<-aic
                  best$fml<-fml()
            }
            list(model=model,aic=aic,fml=fml())                 
      })
      output$outcomeselect = renderUI({
                    selectInput('outcome', 'Select the outcome', names(mydata()))
               })
      output$varselect = renderUI({
            checkboxGroupInput('vars', 'Select the covariates that should be included in the Model',
                               names(mydata())[-match(input$outcome,names(mydata()))])
      })
      output$model = renderPrint({
            summary(fitted()$model)
      })


      observeEvent(input$outcome,{
                  step$run <- FALSE
                  best$run <- FALSE
      })

      observeEvent(input$dostep,
      {
            form<-paste(input$outcome," ~ .")
            model=step(lm(as.formula(form),data=mydata()),direction="backward")
            step$run<-TRUE
            step$aic<-AIC(model)
            step$fml<-as.character((model$call))[2]
            step$model<-model
      })

      output$formula = renderText({
            paste(fitted()$fml,"with an AIC of ",format(fitted()$aic,digits=2))
      })
      output$showdata = renderPrint({
            str(mydata())
      })
      output$help = renderUI({
            url<-"http://stat.ethz.ch/R-manual/R-devel/library/datasets/html/"
            p("For the documentation of the data set click",a("here",
              href=paste(url,input$db,".html",sep=""),
              target="_blank"))
      })
      output$plot = renderPlot({
            par(mfrow=c(2,2),oma=c(0,0,3,1))
            plot(fitted()$model)
      })

      output$stepmodel = renderText({
            if (!step$run) 
                  paste("The 'step' funtion was not run yet.")
            else
                  paste(step$fml,"with an AIC of ",format(step$aic,digits=2))
      })
      
      
      output$bestmodel = renderText({
            if (!best$run) 
                  paste("No best model yet")
            else
                  paste(best$fml,"with an AIC of ",format(best$aic,digits=2))
      })
      
      
})
