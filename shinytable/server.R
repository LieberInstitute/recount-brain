library('shinycsv')
library('RColorBrewer')
library('DT')
library('shiny')
library('sessioninfo')
recount_brain <- read.csv('recount_brain_v2.csv')

shinyServer(function(input, output, session) {
      
    selectedData <- reactive ({
        ## Don't let users upload their own csv file
        ## shinycsv allows that
        df <- recount_brain
        return(df)
    })
    
    observeEvent(input$palette, {
        updateSliderInput(session, 'colorn',
            max = brewer.pal.info$maxcolors[
            rownames(brewer.pal.info) == input$palette], value = 2)
    })
    
    selectedColor <- reactive({
        brewer.pal(brewer.pal.info$maxcolors[
            rownames(brewer.pal.info) == input$palette],
            input$palette)[input$colorn]
    })
    
    selectInfo <- reactive({
        dropEmpty_row ( selectedData() )[input$raw_data_rows_all,
            input$summary_var]
    })
    
    ## Raw data
    output$raw_data <- DT::renderDataTable(
        DT::datatable( dropEmpty_row ( selectedData() ),
            style = 'bootstrap', rownames = FALSE, filter = 'top',
            options = list(pageLength = 10) )
    )
    
    ## Raw summary
    output$raw_summary <- renderPrint(
        summary( dropEmpty_row ( selectedData() )[input$raw_data_rows_all, ] ),
        width = 80
    )
    
    ## Input options for which variable to plot
    output$summary <- renderUI({
        selectInput('summary_var', 'Variable to display',
            sort(colnames(selectedData())) )
    })
    
    ## One variable plot
    output$summary_plot <- renderPlot({
        info <- dropEmpty_row ( selectedData() )[input$raw_data_rows_all,
            input$summary_var]
        plot_oneway(info, input$summary_var, selectedColor())
    })
    
    ## One variable summary: type of summary depends on the type of variable
    output$summary_info <- renderUI({
        info <- selectInfo()
        if(class(info) == 'numeric') {
            verbatimTextOutput('summary_stat')
        } else {
            tableOutput('summary_table')
        }
    })    
    output$summary_stat <- renderPrint({ stat_summary(selectInfo()) },
        width = 60)
    output$summary_table <- renderTable({
        table_summary(selectInfo())        
    })
    
    ## Code for one variable plot
    output$plot_code_one <- renderPrint({
        code <- plot_code(filename = 'recount_brain_v2.csv', fulldata = selectedData(),
        selection = input$raw_data_rows_all, x = input$summary_var,
        color = selectedColor(), pal = input$palette)
        cat(code)
    })
    
    
    ## Input options for displaying two variables
    output$summary_two_x <- renderUI({
        selectInput('summary_var_x', 'Variable to display on X axis',
            sort(colnames(selectedData())) )
    })
    output$summary_two_y <- renderUI({
        selectInput('summary_var_y', 'Variable to display on Y axis',
            sort(colnames(selectedData())) )
    })
    
    ## Two-way plot
    output$summary_plot_two <- renderPlot({
        input$goTwo
        
        x <- isolate(dropEmpty_row ( selectedData() )[input$raw_data_rows_all,
            input$summary_var_x])
        y <- isolate(dropEmpty_row ( selectedData() )[input$raw_data_rows_all,
            input$summary_var_y])
        isolate(plot_twoway(x, y, input$summary_var_x, input$summary_var_y,
            selectedColor(), input$palette))
    })
    
    ## Two-way table
    output$summary_table_two <- renderPrint({
        input$goTwo
        
        x <- isolate(dropEmpty_row ( selectedData() )[input$raw_data_rows_all,
            input$summary_var_x])
        y <- isolate(dropEmpty_row ( selectedData() )[input$raw_data_rows_all,
            input$summary_var_y])
        if(length(x) == 0) return(NULL)
        isolate(table(x, y, useNA = 'ifany'))
    }, width = 60)
    
    ## Code for two-way plot
    output$plot_code_two <- renderPrint({
        input$goTwo
        
        code <- plot_code(filename = 'recount_brain_v2.csv', fulldata = selectedData(),
        selection = input$raw_data_rows_all, x = input$summary_var_x,
        y = input$summary_var_y, color = selectedColor(),
        pal = input$palette)
        cat(code)
    })
    
   
    ## Download selected data
    output$downloadData <- downloadHandler(
        filename = function() { paste0('recount_brain_v2_selection_', Sys.time(), '.csv') },
        content = function(file) {
            current <- dropEmpty_row(selectedData() )[input$raw_data_rows_all, ]
            write.csv(current, file, row.names = FALSE)
        }
    )
    
    ## Download raw summary table
    output$download_summary <- downloadHandler(
        filename = function() {
            paste0('recount_brain_v2_raw_summary_', Sys.time(), '.csv')
        },
        content = function(file) {
            write.csv(summary(
                dropEmpty_row(selectedData())[input$raw_data_rows_all, ] ),
                file = file, na = '', row.names = FALSE)
        }
    )
    
    ## Colors
    output$colors <- renderPlot({display.brewer.all()}, height = 800)

    ## Reproducibility info
    output$session_info <- renderPrint(session_info(), width = 120)
    
    
})
        