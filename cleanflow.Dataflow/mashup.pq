[StagingDefinition = [Kind = "FastCopy"]]
section Section1;
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "BronzeSales_DataDestination", IsNewTarget = false], Settings = [Kind = "Manual", AllowCreation = false, ColumnSettings = [Mappings = {[SourceColumnName = "sale_id", DestinationColumnName = "sale_id"], [SourceColumnName = "date", DestinationColumnName = "date"], [SourceColumnName = "cust_first_name", DestinationColumnName = "cust_first_name"], [SourceColumnName = "cust_surname", DestinationColumnName = "cust_surname"], [SourceColumnName = "quantity", DestinationColumnName = "quantity"], [SourceColumnName = "total_value", DestinationColumnName = "total_value"], [SourceColumnName = "product_id", DestinationColumnName = "product_id"], [SourceColumnName = "year", DestinationColumnName = "year"], [SourceColumnName = "month", DestinationColumnName = "month"], [SourceColumnName = "month_name", DestinationColumnName = "month_name"]}], DynamicSchema = false, UpdateMethod = [Kind = "Replace"], TypeSettings = [Kind = "Table"]]]}]
shared BronzeSales = let
  Source = Lakehouse.Contents(null),
  Navigation = Source{[workspaceId = "3f838aca-9ea2-4acf-b2f2-efbfc0f342c4"]}[Data],
  #"Navigation 1" = Navigation{[lakehouseId = "5d1fab96-7baa-454c-854e-58d970c0e339"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[Id = "BronzeSales", ItemKind = "Table"]}[Data],
  #"Split column by delimiter" = Table.SplitColumn(#"Navigation 2", "customer_name", Splitter.SplitTextByDelimiter(" "), {"customer_name.1", "customer_name.2"}),
  #"Renamed columns" = Table.RenameColumns(#"Split column by delimiter", {{"customer_name.1", "cust_first_name"}, {"customer_name.2", "cust_surname"}}),
  #"Changed column type" = let
    // Your existing step
    #"Changed Type" = Table.TransformColumnTypes(
        #"Renamed columns",
        {
            {"date", type date},
            {"quantity", Int64.Type},
            {"total_value", Currency.Type}
        }
    ),

    // Add Year column
    #"Added Year" = Table.AddColumn(
        #"Changed Type",
        "year",
        each Date.Year([date]),
        Int64.Type
    ),

    // Add Month Number column
    #"Added Month" = Table.AddColumn(
        #"Added Year",
        "month",
        each Date.Month([date]),
        Int64.Type
    ),

    // Add Month Name column
    #"Added Month Name" = Table.AddColumn(
        #"Added Month",
        "month_name",
        each Date.MonthName([date]),
        type text
    )

in
    #"Added Month Name",
  #"Changed column type 1" = Table.TransformColumnTypes(#"Changed column type", {{"total_value", type number}}),
  #"Removed duplicates" = Table.Distinct(#"Changed column type 1", {"sale_id"}),
  #"Filtered rows" = Table.SelectRows(#"Removed duplicates", each [total_value] > 0)
in
  #"Filtered rows";
shared BronzeSales_DataDestination = let
  Pattern = Lakehouse.Contents([CreateNavigationProperties = false, EnableFolding = false, HierarchicalNavigation = null]),
  Navigation_1 = Pattern{[workspaceId = "3f838aca-9ea2-4acf-b2f2-efbfc0f342c4"]}[Data],
  Navigation_2 = Navigation_1{[lakehouseId = "5d1fab96-7baa-454c-854e-58d970c0e339"]}[Data],
  TableNavigation = Navigation_2{[Id = "silverSales", ItemKind = "Table"]}[Data]
in
  TableNavigation;
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "rejected_rows_DataDestination", IsNewTarget = false], Settings = [Kind = "Manual", AllowCreation = false, ColumnSettings = [Mappings = {[SourceColumnName = "sale_id", DestinationColumnName = "sale_id"], [SourceColumnName = "date", DestinationColumnName = "date"], [SourceColumnName = "cust_first_name", DestinationColumnName = "cust_first_name"], [SourceColumnName = "cust_surname", DestinationColumnName = "cust_surname"], [SourceColumnName = "quantity", DestinationColumnName = "quantity"], [SourceColumnName = "product_id", DestinationColumnName = "product_id"], [SourceColumnName = "year", DestinationColumnName = "year"], [SourceColumnName = "month", DestinationColumnName = "month"], [SourceColumnName = "month_name", DestinationColumnName = "month_name"]}], DynamicSchema = false, UpdateMethod = [Kind = "Append"], TypeSettings = [Kind = "Table"]]]}]
shared rejected_rows = let
  Source = Lakehouse.Contents(null),
  Navigation = Source{[workspaceId = "3f838aca-9ea2-4acf-b2f2-efbfc0f342c4"]}[Data],
  #"Navigation 1" = Navigation{[lakehouseId = "5d1fab96-7baa-454c-854e-58d970c0e339"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[Id = "BronzeSales", ItemKind = "Table"]}[Data],
  #"Split column by delimiter" = Table.SplitColumn(#"Navigation 2", "customer_name", Splitter.SplitTextByDelimiter(" "), {"customer_name.1", "customer_name.2"}),
  #"Renamed columns" = Table.RenameColumns(#"Split column by delimiter", {{"customer_name.1", "cust_first_name"}, {"customer_name.2", "cust_surname"}}),
  #"Changed column type" = let
    // Your existing step
    #"Changed Type" = Table.TransformColumnTypes(
        #"Renamed columns",
        {
            {"date", type date},
            {"quantity", Int64.Type},
            {"total_value", Currency.Type}
        }
    ),

    // Add Year column
    #"Added Year" = Table.AddColumn(
        #"Changed Type",
        "year",
        each Date.Year([date]),
        Int64.Type
    ),

    // Add Month Number column
    #"Added Month" = Table.AddColumn(
        #"Added Year",
        "month",
        each Date.Month([date]),
        Int64.Type
    ),

    // Add Month Name column
    #"Added Month Name" = Table.AddColumn(
        #"Added Month",
        "month_name",
        each Date.MonthName([date]),
        type text
    )

in
    #"Added Month Name",
  #"Changed column type 1" = Table.TransformColumnTypes(#"Changed column type", {{"total_value", type number}}),
  #"Removed duplicates" = Table.Distinct(#"Changed column type 1", {"sale_id"}),
  #"Changed column type 2" = Table.TransformColumnTypes(#"Removed duplicates", {{"quantity", type text}, {"total_value", type number}, {"year", type text}, {"month", type text}, {"date", type text}}),
  #"Filtered rows" = Table.SelectRows(#"Changed column type 2", each [total_value] <= 0)
in
  #"Filtered rows";
shared rejected_rows_DataDestination = let
  Pattern = Lakehouse.Contents([CreateNavigationProperties = false, EnableFolding = false, HierarchicalNavigation = null, PreserveOrder = null]),
  Navigation_1 = Pattern{[workspaceId = "3f838aca-9ea2-4acf-b2f2-efbfc0f342c4"]}[Data],
  Navigation_2 = Navigation_1{[lakehouseId = "5d1fab96-7baa-454c-854e-58d970c0e339"]}[Data],
  TableNavigation = Navigation_2{[Id = "silver_rejected_rows", ItemKind = "Table"]}[Data]
in
  TableNavigation;
