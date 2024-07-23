page1 = {
  page={
  "0"={

    name="Iflows Overview"
        
    # widget_line=false
    # widget_table=false
    # widget_billboard=true
    # widget_bar=true
    # widget_stacked_bar=true

    widget_billboard={
        "0"={
        title = "IFlow Success Ratio for all CPs (%)"
      row    = 1
      column = 1
      width = 3
      height = 3
        query="SELECT (filter(sum(`rb.iflow.count`), where status = 'COMPLETED') / sum(`rb.iflow.count`)) * 100 FROM Metric FACET client"
       critical=true
       warning=true
        warning = 90
        critical= 70
        }
        "1"={
        title = "SAP API Availability"
       row=7
       column=1
       width=2
       height=2
       warning=false
       critical=false
         query="SELECT (filter(sum(`sap.api.status`), WHERE status = 'up') / sum(`sap.api.status`)) * 100 AS 'API Availability' FROM Metric COMPARE WITH 1 day ago"
        }
        "2"={
        title = "Total Iflows Count"
      row=9
      column = 1
      width = 3
      height = 2
      warning=false
      critical=false
    query="SELECT sum(rb.iflow.count) as 'Total Iflows' FROM Metric WHERE status is not null SINCE 1 hour ago COMPARE WITH 1 week ago WHERE (client = 'All' or 'All' = 'All')"
        }
    }
    widget_stacked_bar={
        "0"={
              title = "IFlow Success Ratio"
      row    = 1
      column = 4
      width = 5
      height = 3
        query = "SELECT percentage(sum(`rb.iflow.count`), WHERE status = 'COMPLETED_WITH_ERROR') as 'COMPLETED WITH ERROR', percentage(sum(`rb.iflow.count`), WHERE status = 'FAILED') as 'FAILED', percentage(sum(`rb.iflow.count`), WHERE status = 'COMPLETED') as 'COMPLETED', percentage(sum(`rb.iflow.count`), WHERE status = 'ESCALATED') as 'ESCALATED', percentage(sum(`rb.iflow.count`), WHERE status = 'RETRY') as 'RETRY', percentage(sum(`rb.iflow.count`), WHERE status = 'PROCESSING') as 'PROCESSING', percentage(sum(`rb.iflow.count`), WHERE status = 'DISCARDED') as 'DISCARDED', percentage(sum(`rb.iflow.count`), WHERE status like '%CANCELED%') as 'CANCELED', percentage(sum(`rb.iflow.count`), WHERE status like 'ABANDONED') as 'ABANDONED' FROM Metric WHERE (client = 'All' or 'All' = 'All') TIMESERIES auto"
        colors={
            "0"={
                color= "#2d8b6f"
                series_name = "COMPLETED"
            }
            "1"={
                 color="#e15151"
                series_name= "FAILED"
            }
        }
        }
    
        "1"={
             title = "SAP API Availability"
      row=7
      column = 3
      width = 10
      height = 2
        query="SELECT (filter(sum(`sap.api.status`), WHERE status = 'up') / sum(`sap.api.status`)) * 100 as 'Sap api status' FROM Metric TIMESERIES"
        colors={
            "0"={
                  color = "#7f4997"
          series_name = "Binop"
            }
        }
        }
        "2"={
           title="Total IFlow Count"
      row = 9
      column = 4
      width = 9
      height = 2
        query="SELECT (filter(sum(`sap.api.status`), WHERE status = 'up') / sum(`sap.api.status`)) * 100 as 'Sap api status' FROM Metric TIMESERIES"
       colors={
        "0"={
             color="#9901fe"
        series_name="ESCALATED"
        }
        "1"={
           color="#00aaff"
         series_name ="COMPLETED"  
        }
        "2"={
             color="#f7cf02"
          series_name = "COMPLETED_WITH_ERROR"
        }
        "3"={
            color="#ff0505"
        series_name = "FAILED"
        }
       }
        }
      

    }
    widget_bar={
        "0"={
       title = "IFlow Count by ID (Top 25)"
       row    = 1
      column = 9
       width = 4
       height = 6
         query= "SELECT sum(`rb.iflow.count`) FROM Metric WHERE (client = 'All' or 'All' = 'All') FACET integration_flow_id LIMIT 25"
       }
         "1"={
               title="Iflow Subsystems"
                 row=4
                  column=1
                  width=4
                  height=3
      query="SELECT sum(`rb.iflow.count`) FROM Metric WHERE (client = 'All' or 'All' = 'All') where subsystem != 'UNKNOWN' FACET subsystem LIMIT 25"
       } 
        "2"={
                 title="Status by Iflow Count"
      row=4
      column=5
      width=4
      height = 3
      query="FROM Metric SELECT sum(rb.iflow.count) as 'IflowCount' FACET status WHERE (client = 'All' or 'All' = 'All')" 
        }
        "3"={
            title = "CustomStatus Errors (Top 10)"
  row = 11
  column = 1
  width = 6
  height = 3
    query= <<-Q
    With if(error like '%results":[]%', aparse(error, '%[*]%')) as nuL, aparse(error, '%"errorNote","Value":"*\\n*\\n*\\\\*\\\\*\\\\"%') as (e1, e2, e3, e4, e5), if(error LIKE '%cdcId%' and eventtype() like '%FailedIFlow%', aparse(error, '*=% *')) as (cd1, cd2), aparse(error, '* Exchange[ID%].*. Exchange[ID%]. *') as (msg1, msg2, msg3), if(error like '%"Name":"description","Value":"Unknown user"%' or error like '%"Name":"description","Value":"Identities is invalid"%' or error like '%"Name":"description","Value":""%', aparse(error, '%description","Value":"*"%'), if(error like '%</a>."}%', aparse(error, '%description","Value":"*"}%'), aparse(error, '%description","Value":"*",%'))) as Description FROM CompletedWithErrorIFlow, CustomStatusIflows with If(eventtype() like 'CompletedWithErrorIFlow' or eventtype() like '%CustomStatusIflows%' and error not like '{%', error, if(Description is not null, if(Description like '%Phone number:%', aparse(Description, '%Phone number: % *:%'), Description), if(error like '%"errorNote","Value":""%', aparse(error, '%"Name":"errorNote"*"Value"%'), if(error like '{%' and error like '%search parameters%', aparse(error, '%"errorNote","Value":"*"}%'), if(length(error) < 30, error, if(error LIKE '%Exception in%', concat(e1, e2, e3, e4, e5), if(error like '%results":[]%', nuL, if(error LIKE '%cdcId%', concat(cd1, ' ', cd2), if(error like '%Exchange[ID%%', concat(msg1, msg2, msg3), if(eventType() like '%CompletedWithErrorIFlow%' or eventtype() like '%CustomStatusIflows%', aparse(error, '%errorNote","Value":"*"%'), if(error like '%message is :%', aparse(error, '*message is :%'), if(eventType() like 'FailedIFlow' and error not like '%message is :%', error)))))))))))) as AllErrors SELECT count(error) facet AllErrors WHERE (client = 'All' or 'All' = 'All') limit 10
    Q  
        }
    "3"={
         title="Failed Errors (Top 10)"
  row=11
  column = 7
  width = 6
  height = 3

    query = <<-Q
    With if(error like '%results":[]%', aparse(error, '%[*]%')) as nuL, aparse(error, '%"errorNote","Value":"*\\n*\\n*\\\\*\\\\*\\\\"%') as (e1, e2, e3, e4, e5), if(error LIKE '%cdcId%' and eventtype() like '%FailedIFlow%', aparse(error, '*=% *')) as (cd1, cd2), aparse(error, '* Exchange[ID%].*. Exchange[ID%]. *') as (msg1, msg2, msg3), if(error like '%"Name":"description","Value":"Unknown user"%' or error like '%"Name":"description","Value":"Identities is invalid"%' or error like '%"Name":"description","Value":""%', aparse(error, '%description","Value":"*"%'), if(error like '%</a>."}%', aparse(error, '%description","Value":"*"}%'), aparse(error, '%description","Value":"*",%'))) as Description FROM FailedIFlow with If(eventtype() like 'CompletedWithErrorIFlow' or eventtype() like '%CustomStatusIflows%' and error not like '{%', error, if(Description is not null, if(Description like '%Phone number:%', aparse(Description, '%Phone number: % *:%'), Description), if(error like '%"errorNote","Value":""%', aparse(error, '%"Name":"errorNote"*"Value"%'), if(error like '{%' and error like '%search parameters%', aparse(error, '%"errorNote","Value":"*"}%'), if(length(error) < 30, error, if(error LIKE '%Exception in%', concat(e1, e2, e3, e4, e5), if(error like '%results":[]%', nuL, if(error LIKE '%cdcId%', concat(cd1, ' ', cd2), if(error like '%Exchange[ID%%', concat(msg1, msg2, msg3), if(eventType() like '%CompletedWithErrorIFlow%' or eventtype() like '%CustomStatusIflows%', aparse(error, '%errorNote","Value":"*"%'), if(error like '%message is :%', aparse(error, '*message is :%'), if(eventType() like 'FailedIFlow' and error not like '%message is :%', error)))))))))))) as AllErrors SELECT count(error) facet AllErrors limit 10 WHERE (client = 'All' or 'All' = 'All')
    Q
    }


    }}
"1"={
  name = "Iflow Error Investigation"
    # widget_stacked_bar=false
    # widget_bar=true
    # widget_billboard=true
    # widget_line=true
    # widget_table=true
    
    widget_bar={
        "0"={
              title = "All Iflow Errors"
      row    = 1
      column = 1
      width  = 5
      height = 3
      
        query= <<-Q
        With aparse(error, '%Exchange[*]%Exchange[*]%') as (ExchangeId, ExchangeId2), if(error like '%results":[]%', aparse(error, '%[*]%')) as nuL, aparse(error, '%"errorNote","Value":"*\\n*\\n*\\\\*\\\\*\\\\"%') as (e1, e2, e3, e4, e5), if(error LIKE '%cdcId%' and eventtype() like '%FailedIFlow%', aparse(error, '*=% *')) as (cd1, cd2), aparse(error, '* Exchange[ID%].*. Exchange[ID%]. *') as (msg1, msg2, msg3), if(error like '%"Name":"description","Value":"Unknown user"%' or error like '%"Name":"description","Value":"Identities is invalid"%' or error like '%"Name":"description","Value":""%', aparse(error, '%description","Value":"*"%'), if(error like '%</a>."}%', aparse(error, '%description","Value":"*"}%'), aparse(error, '%description","Value":"*",%'))) as Description FROM CompletedWithErrorIFlow, FailedIFlow, CustomStatusIflows with If(eventtype() like 'CompletedWithErrorIFlow' or eventtype() like '%CustomStatusIflows%' and error not like '{%', error, if(Description is not null, if(Description like '%Phone number:%', aparse(Description, '%Phone number: % *:%'), Description), if(error like '%"errorNote","Value":""%', aparse(error, '%"Name":"errorNote"*"Value"%'), if(error like '{%' and error like '%search parameters%', aparse(error, '%"errorNote","Value":"*"}%'), if(length(error) < 30, error, if(error LIKE '%Exception in%', concat(e1, e2, e3, e4, e5), if(error like '%results":[]%', nuL, if(error LIKE '%cdcId%', concat(cd1, ' ', cd2), if(error like '%Exchange[ID%%', concat(msg1, msg2, msg3), if(eventType() like '%CompletedWithErrorIFlow%' or eventtype() like '%CustomStatusIflows%', aparse(error, '%errorNote","Value":"*"%'), if(error like '%message is :%', aparse(error, '*message is :%'), if(eventType() like 'FailedIFlow' and error not like '%message is :%', error)))))))))))) as AllErrors SELECT count(error) facet AllErrors limit max WHERE (client = 'All' or 'All' = 'All')
        Q
        }
        "1"={
          title = "Iflow Status"
  row=4
  column=1
  width=4
  height=3
    query = <<-Q
    With aparse(error, '%Exchange[*]%Exchange[*]%') as (ExchangeId, ExchangeId2), if(error like '%results":[]%', aparse(error, '%[*]%')) as nuL, aparse(error, '%"errorNote","Value":"*\\n*\\n*\\\\*\\\\*\\\\"%') as (e1, e2, e3, e4, e5), if(error LIKE '%cdcId%' and eventtype() like '%FailedIFlow%', aparse(error, '*=% *')) as (cd1, cd2), aparse(error, '* Exchange[ID%].*. Exchange[ID%]. *') as (msg1, msg2, msg3), if(error like '%"Name":"description","Value":"Unknown user"%' or error like '%"Name":"description","Value":"Identities is invalid"%' or error like '%"Name":"description","Value":""%', aparse(error, '%description","Value":"*"%'), if(error like '%</a>."}%', aparse(error, '%description","Value":"*"}%'), aparse(error, '%description","Value":"*",%'))) as Description FROM CompletedWithErrorIFlow, FailedIFlow, CustomStatusIflows with If(eventtype() like 'CompletedWithErrorIFlow' or eventtype() like '%CustomStatusIflows%' and error not like '{%', error, if(Description is not null, if(Description like '%Phone number:%', aparse(Description, '%Phone number: % *:%'), Description), if(error like '%"errorNote","Value":""%', aparse(error, '%"Name":"errorNote"*"Value"%'), if(error like '{%' and error like '%search parameters%', aparse(error, '%"errorNote","Value":"*"}%'), if(length(error) < 30, error, if(error LIKE '%Exception in%', concat(e1, e2, e3, e4, e5), if(error like '%results":[]%', nuL, if(error LIKE '%cdcId%', concat(cd1, ' ', cd2), if(error like '%Exchange[ID%%', concat(msg1, msg2, msg3), if(eventType() like '%CompletedWithErrorIFlow%' or eventtype() like '%CustomStatusIflows%', aparse(error, '%errorNote","Value":"*"%'), if(error like '%message is :%', aparse(error, '*message is :%'), if(eventType() like 'FailedIFlow' and error not like '%message is :%', error)))))))))))) as AllErrors SELECT count(error) facet status limit max WHERE (client = 'All' or 'All' = 'All')
    Q  
        }
       "2"={
         title = "Iflow Subsystems"
  row = 4
  column = 5
  width = 4
  height = 3
    query = <<-Q
    With aparse(error, '%Exchange[*]%Exchange[*]%') as (ExchangeId, ExchangeId2), if(error like '%results":[]%', aparse(error, '%[*]%')) as nuL, aparse(error, '%"errorNote","Value":"*\\n*\\n*\\\\*\\\\*\\\\"%') as (e1, e2, e3, e4, e5), if(error LIKE '%cdcId%' and eventtype() like '%FailedIFlow%', aparse(error, '*=% *')) as (cd1, cd2), aparse(error, '* Exchange[ID%].*. Exchange[ID%]. *') as (msg1, msg2, msg3), if(error like '%"Name":"description","Value":"Unknown user"%' or error like '%"Name":"description","Value":"Identities is invalid"%' or error like '%"Name":"description","Value":""%', aparse(error, '%description","Value":"*"%'), if(error like '%</a>."}%', aparse(error, '%description","Value":"*"}%'), aparse(error, '%description","Value":"*",%'))) as Description FROM CompletedWithErrorIFlow, FailedIFlow, CustomStatusIflows with If(eventtype() like 'CompletedWithErrorIFlow' or eventtype() like '%CustomStatusIflows%' and error not like '{%', error, if(Description is not null, if(Description like '%Phone number:%', aparse(Description, '%Phone number: % *:%'), Description), if(error like '%"errorNote","Value":""%', aparse(error, '%"Name":"errorNote"*"Value"%'), if(error like '{%' and error like '%search parameters%', aparse(error, '%"errorNote","Value":"*"}%'), if(length(error) < 30, error, if(error LIKE '%Exception in%', concat(e1, e2, e3, e4, e5), if(error like '%results":[]%', nuL, if(error LIKE '%cdcId%', concat(cd1, ' ', cd2), if(error like '%Exchange[ID%%', concat(msg1, msg2, msg3), if(eventType() like '%CompletedWithErrorIFlow%' or eventtype() like '%CustomStatusIflows%', aparse(error, '%errorNote","Value":"*"%'), if(error like '%message is :%', aparse(error, '*message is :%'), if(eventType() like 'FailedIFlow' and error not like '%message is :%', error)))))))))))) as AllErrors select count(error) facet subsystem WHERE (client = 'All' or 'All' = 'All')
    Q
    }

}
widget_billboard={
    "0"={
          title = "All Errors Count"
   column=9
    row=4
    height=4
    width=3
    warning=false
       critical=false
    query = <<-Q
    With aparse(error, '%Exchange[*]%Exchange[*]%') as (ExchangeId, ExchangeId2), if(error like '%results":[]%', aparse(error, '%[*]%')) as nuL, aparse(error, '%"errorNote","Value":"*\\n*\\n*\\\\*\\\\*\\\\"%') as (e1, e2, e3, e4, e5), if(error LIKE '%cdcId%' and eventtype() like '%FailedIFlow%', aparse(error, '*=% *')) as (cd1, cd2), aparse(error, '* Exchange[ID%].*. Exchange[ID%]. *') as (msg1, msg2, msg3), if(error like '%"Name":"description","Value":"Unknown user"%' or error like '%"Name":"description","Value":"Identities is invalid"%' or error like '%"Name":"description","Value":""%', aparse(error, '%description","Value":"*"%'), if(error like '%</a>."}%', aparse(error, '%description","Value":"*"}%'), aparse(error, '%description","Value":"*",%'))) as Description FROM CompletedWithErrorIFlow, FailedIFlow, CustomStatusIflows with If(eventtype() like 'CompletedWithErrorIFlow' or eventtype() like '%CustomStatusIflows%' and error not like '{%', error, if(Description is not null, if(Description like '%Phone number:%', aparse(Description, '%Phone number: % *:%'), Description), if(error like '%"errorNote","Value":""%', aparse(error, '%"Name":"errorNote"*"Value"%'), if(error like '{%' and error like '%search parameters%', aparse(error, '%"errorNote","Value":"*"}%'), if(length(error) < 30, error, if(error LIKE '%Exception in%', concat(e1, e2, e3, e4, e5), if(error like '%results":[]%', nuL, if(error LIKE '%cdcId%', concat(cd1, ' ', cd2), if(error like '%Exchange[ID%%', concat(msg1, msg2, msg3), if(eventType() like '%CompletedWithErrorIFlow%' or eventtype() like '%CustomStatusIflows%', aparse(error, '%errorNote","Value":"*"%'), if(error like '%message is :%', aparse(error, '*message is :%'), if(eventType() like 'FailedIFlow' and error not like '%message is :%', error)))))))))))) as AllErrors SELECT count(AllErrors) as 'Total Errors' limit max compare with 1 week ago WHERE (client = 'All' or 'All' = 'All')
    Q
  }
    }
    widget_line={
        "0"={
              title= "All Errors Count"

      row    = 1
      column = 6
      width  = 7
      height = 3
        query = <<-Q
With aparse(error, '%Exchange[*]%Exchange[*]%') as (ExchangeId, ExchangeId2), if(error like '%results":[]%', aparse(error, '%[*]%')) as nuL, aparse(error, '%"errorNote","Value":"*\\n*\\n*\\\\*\\\\*\\\\"%') as (e1, e2, e3, e4, e5), if(error LIKE '%cdcId%' and eventtype() like '%FailedIFlow%', aparse(error, '*=% *')) as (cd1, cd2), aparse(error, '* Exchange[ID%].*. Exchange[ID%]. *') as (msg1, msg2, msg3), if(error like '%"Name":"description","Value":"Unknown user"%' or error like '%"Name":"description","Value":"Identities is invalid"%' or error like '%"Name":"description","Value":""%', aparse(error, '%description","Value":"*"%'), if(error like '%</a>."}%', aparse(error, '%description","Value":"*"}%'), aparse(error, '%description","Value":"*",%'))) as Description FROM CompletedWithErrorIFlow, FailedIFlow, CustomStatusIflows with If(eventtype() like 'CompletedWithErrorIFlow' or eventtype() like '%CustomStatusIflows%' and error not like '{%', error, if(Description is not null, if(Description like '%Phone number:%', aparse(Description, '%Phone number: % *:%'), Description), if(error like '%"errorNote","Value":""%', aparse(error, '%"Name":"errorNote"*"Value"%'), if(error like '{%' and error like '%search parameters%', aparse(error, '%"errorNote","Value":"*"}%'), if(length(error) < 30, error, if(error LIKE '%Exception in%', concat(e1, e2, e3, e4, e5), if(error like '%results":[]%', nuL, if(error LIKE '%cdcId%', concat(cd1, ' ', cd2), if(error like '%Exchange[ID%%', concat(msg1, msg2, msg3), if(eventType() like '%CompletedWithErrorIFlow%' or eventtype() like '%CustomStatusIflows%', aparse(error, '%errorNote","Value":"*"%'), if(error like '%message is :%', aparse(error, '*message is :%'), if(eventType() like 'FailedIFlow' and error not like '%message is :%', error)))))))))))) as AllErrors SELECT count(AllErrors) as 'Total Errors' limit max compare with 1 week ago timeseries WHERE (client = 'All' or 'All' = 'All') 
     Q
     colors={
        "0"={
            color ="#068e0a"
         series_name= "ErrorCount"
        }
        "1"={
             color = "#d67200"
                 series_name= "Previous ErrorCount"
        }
     }
      }

        }
        widget_table={
          "0"={
       title = "IFlow Error Overview"
  row=7
  column=1
  width=12
  height=5
    query = <<-Q
   With aparse(error, '%Exchange[*]%Exchange[*]%') as (ExchangeId, ExchangeId2), if(error like '%results":[]%', aparse(error, '%[*]%')) as nuL, aparse(error, '%"errorNote","Value":"*\\n*\\n*\\\\*\\\\*\\\\"%') as (e1, e2, e3, e4, e5), if(error LIKE '%cdcId%' and eventtype() like '%FailedIFlow%', aparse(error, '*=% *')) as (cd1, cd2), aparse(error, '* Exchange[ID%].*. Exchange[ID%]. *') as (msg1, msg2, msg3), if(error like '%"Name":"description","Value":"Unknown user"%' or error like '%"Name":"description","Value":"Identities is invalid"%' or error like '%"Name":"description","Value":""%', aparse(error, '%description","Value":"*"%'), if(error like '%</a>."}%', aparse(error, '%description","Value":"*"}%'), aparse(error, '%description","Value":"*",%'))) as Description FROM CompletedWithErrorIFlow, FailedIFlow, CustomStatusIflows with If(eventtype() like 'CompletedWithErrorIFlow' or eventtype() like '%CustomStatusIflows%' and error not like '{%', error, if(Description is not null, if(Description like '%Phone number:%', aparse(Description, '%Phone number: % *:%'), Description), if(error like '%"errorNote","Value":""%', aparse(error, '%"Name":"errorNote"*"Value"%'), if(error like '{%' and error like '%search parameters%', aparse(error, '%"errorNote","Value":"*"}%'), if(length(error) < 30, error, if(error LIKE '%Exception in%', concat(e1, e2, e3, e4, e5), if(error like '%results":[]%', nuL, if(error LIKE '%cdcId%', concat(cd1, ' ', cd2), if(error like '%Exchange[ID%%', concat(msg1, msg2, msg3), if(eventType() like '%CompletedWithErrorIFlow%' or eventtype() like '%CustomStatusIflows%', aparse(error, '%errorNote","Value":"*"%'), if(error like '%message is :%', aparse(error, '*message is :%'), if(eventType() like 'FailedIFlow' and error not like '%message is :%', error)))))))))))) as AllErrors SELECT status, AllErrors, Description as 'Description', aparse(error, '%status","Value":"*"%') as 'statusCode', subsystem, integration_flow_id, messageGuid, error, eventtype() as 'EventName' limit max WHERE (client = 'All' or 'All' = 'All')
    Q
          }
        }
    }
  }
 
}
