resource "newrelic_one_dashboard" "Dashboard-tf" {
  name = "Dashboard-tf"
  permissions = "public_read_write" #public,public_read_only=default
    
  dynamic "page" {
    for_each=  var.page1.page
    content {
        name= page.value.name
    dynamic "widget_billboard" {
       for_each = try(page.value.widget_billboard,{}) 
    #  for_each = page.value.widget_billboard
      content {
      title = widget_billboard.value.title
      row=widget_billboard.value.row
      column =widget_billboard.value.column
      width =widget_billboard.value.width
      height=widget_billboard.value.height
      nrql_query {
        query=widget_billboard.value.query
      } 
        warning  = widget_billboard.value.warning != "" ? widget_billboard.value.warning : null
        critical = widget_billboard.value.critical != "" ? widget_billboard.value.critical : null
      }
  } 
    dynamic "widget_stacked_bar" {
         for_each = try(page.value.widget_stacked_bar,{}) 
      #  for_each = page.value.widget_stacked_bar
      content {
        title = widget_stacked_bar.value.title
      row=widget_stacked_bar.value.row
      column =widget_stacked_bar.value.column
      width =widget_stacked_bar.value.width
      height=widget_stacked_bar.value.height
       nrql_query {
        query=widget_stacked_bar.value.query
      }
      dynamic "colors" {
         for_each = widget_stacked_bar.value.colors
       content {
        series_overrides{
            color=colors.value.color
            series_name=colors.value.series_name
            }
        }
      }
      }
    }
    dynamic widget_bar{
        for_each = try(page.value.widget_bar,{}) 
        # for_each = page.value.widget_bar
        content {
          title = widget_bar.value.title
      row=widget_bar.value.row
      column =widget_bar.value.column
      width =widget_bar.value.width
      height=widget_bar.value.height
       nrql_query {
        query=widget_bar.value.query
      }
        }
    }
    dynamic "widget_line" {
        for_each = try(page.value.widget_line,{}) 
        #  for_each =page.value.widget_line
        content {
        title = widget_line.value.title
        row=widget_line.value.row
        column =widget_line.value.column
        width =widget_line.value.width
        height=widget_line.value.height
        nrql_query {
            query=widget_line.value.query
            }
        dynamic "colors" {
          for_each = widget_line.value.colors
          content {
            series_overrides{
                color=colors.value.color
                series_name=colors.value.series_name
        }
        }
    }
    }
  }
  dynamic "widget_table" {
    for_each = try(page.value.widget_table,{}) 
    #  for_each = page.value.widget_table
    content {
      title = widget_table.value.title
        row=widget_table.value.row
        column =widget_table.value.column
        width =widget_table.value.width
        height=widget_table.value.height
        nrql_query {
            query=widget_table.value.query
            }
    }
  }
  }
  }
    variable {
      default_values     = ["*"]
      is_multi_selection = true
      item {
        title = "RBLeipzig"
        value = "RBLeipzig"
      }
      item {
        title = "ECRBSalzburg"
        value = "ECRBSalzburg"
      }
      item {
        title = "RBMuenchen"
        value = "RBMuenchen"
      }
      item {
        title = "RBMH"
        value = "RBMH"
      }
            item {
        title = "SAPG"
        value = "SAPG"
      }
      name = "variable"

      replacement_strategy = "default"
      title                = "title"
      type                 = "enum"
  }
  }
    

    