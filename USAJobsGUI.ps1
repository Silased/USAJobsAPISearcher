## Load WPF
Add-Type -AssemblyName presentationframework, presentationcore
[void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void][System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")

## Define USAJobs API Search Entry Points
$USAJobsSearchAPI = "https://data.usajobs.gov/api/search?"
$USAJobsHistoricSearchAPI = "https://data.usajobs.gov/api/historicjoa?"

$inputXML = @"
<Window x:Class="System.Windows.Window"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="USAJobs Searcher" SizeToContent="WidthAndHeight" MinWidth="550" Background="#FF313338">

    <Window.Resources>
        <BooleanToVisibilityConverter x:Key="BoolToVis"/>
    </Window.Resources>

    <ScrollViewer VerticalScrollBarVisibility="Auto">
        <StackPanel Margin="20">
            <TextBlock Text="USAJobs Searcher" 
                       HorizontalAlignment="Center" FontSize="28" FontFamily="Cascadia Mono"
                       Foreground="#FFF2F3F5" Margin="0,0,0,20"/>

            <GroupBox Header="Search Criteria" FontSize="16" Foreground="#FFF2F3E6"
                      Background="#FF313338" Margin="0,0,0,20">
                <StackPanel Margin="10">
                    <Grid Margin="0,0,0,10">
                        <Grid.RowDefinitions>
                            <RowDefinition Height="Auto"/>
                            <RowDefinition Height="Auto"/>
                            <RowDefinition Height="Auto"/>
                            <RowDefinition Height="Auto"/>
                        </Grid.RowDefinitions>
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="Auto"/>
                            <ColumnDefinition Width="*"/>
                        </Grid.ColumnDefinitions>

                        <Label Grid.Row="0" Grid.Column="0" Content="Location:" Width="100" Foreground="#FFF2F3F5" VerticalAlignment="Center" Margin="0,5"/>
                        <Grid Grid.Row="0" Grid.Column="1" Margin="0,5">
                            <TextBox x:Name="LocationTextBox" Height="25" FontSize="14" Background="#FFF2F3E9"/>
                            <TextBlock x:Name="LocationHint" Text="Ex: Japan, California, Europe" 
                                       IsHitTestVisible="False" VerticalAlignment="Center" Margin="5,0,0,0"
                                       Foreground="DarkGray" HorizontalAlignment="Left">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Visibility" Value="Collapsed"/>
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding Text, ElementName=LocationTextBox}" Value="">
                                                <Setter Property="Visibility" Value="Visible"/>
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Label Grid.Row="1" Grid.Column="0" Content="Job Series:" Width="100" Foreground="#FFF2F3F5" VerticalAlignment="Center" Margin="0,5"/>
                        <Grid Grid.Row="1" Grid.Column="1" Margin="0,5">
                            <TextBox x:Name="JobSeriesTextBox" Height="25" FontSize="14" Background="#FFF2F3E9"/>
                            <TextBlock x:Name="JobSeriesHint" Text="Ex: 2210" 
                                       IsHitTestVisible="False" VerticalAlignment="Center" Margin="5,0,0,0"
                                       Foreground="DarkGray" HorizontalAlignment="Left">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Visibility" Value="Collapsed"/>
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding Text, ElementName=JobSeriesTextBox}" Value="">
                                                <Setter Property="Visibility" Value="Visible"/>
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Label Grid.Row="2" Grid.Column="0" Content="Remote?" Width="100" Foreground="#FFF2F3F5" VerticalAlignment="Center" Margin="0,5"/>
                        <CheckBox x:Name="RemoteJobCheckBox" Grid.Row="2" Grid.Column="1" VerticalAlignment="Center" Margin="0,5"/>

                        <Label Grid.Row="3" Grid.Column="0" Content="Historical?" Width="100" Foreground="#FFF2F3F5" VerticalAlignment="Center" Margin="0,5"/>
                        <CheckBox x:Name="HistoricalCheckBox" Grid.Row="3" Grid.Column="1" VerticalAlignment="Center" Margin="0,5"/>
                    </Grid>

                    <StackPanel x:Name="DatePickersPanel"
            Visibility="{Binding IsChecked, ElementName=HistoricalCheckBox, Converter={StaticResource BoolToVis}}">
                        <Grid Margin="0,0,0,5">
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="Auto"/>
                                <ColumnDefinition Width="*"/>
                            </Grid.ColumnDefinitions>
                            <Label Grid.Column="0" Content="From Date:" Width="100" Foreground="#FFF2F3F5" VerticalAlignment="Center" Margin="0,5"/>
                            <DatePicker x:Name="FromDatePicker" Focusable="False" Grid.Column="1" Margin="0,5,214,5"/>
                        </Grid>
                        <Grid>
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="Auto"/>
                                <ColumnDefinition Width="*"/>
                            </Grid.ColumnDefinitions>
                            <Label Grid.Column="0" Content="To Date:" Width="100" Foreground="#FFF2F3F5" VerticalAlignment="Center" Margin="0,5"/>
                            <DatePicker x:Name="ToDatePicker" Focusable="False" Grid.Column="1" Margin="0,5,214,5"/>
                        </Grid>
                    </StackPanel>

                </StackPanel>
            </GroupBox>

            <GroupBox Header="API Credentials" FontSize="16" Foreground="#FFF2F3E6"
                      Background="#FF313338" Margin="0,0,0,20">
                <Grid Margin="10">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="Auto"/>
                    </Grid.RowDefinitions>
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="Auto"/>
                        <ColumnDefinition Width="*"/>
                    </Grid.ColumnDefinitions>

                    <Label Grid.Row="0" Grid.Column="0" Content="API Email Address:" Foreground="#FFF2F3F5" VerticalAlignment="Center" Margin="0,5"/>
                    <TextBox x:Name="EmailAddressTextBox" Grid.Row="0" Grid.Column="1" Margin="5" Height="25" FontSize="14" Background="#FFF2F3E9"/>

                    <Label Grid.Row="1" Grid.Column="0" Content="API Key:" Foreground="#FFF2F3F5" VerticalAlignment="Center" Margin="0,5"/>
                    <TextBox x:Name="APIKeyTextBox" Grid.Row="1" Grid.Column="1" Margin="5" Height="25" FontSize="14" Background="#FFF2F3E9"/>
                </Grid>
            </GroupBox>

            <StackPanel Orientation="Vertical" HorizontalAlignment="Center" Margin="0,10">
                <Button x:Name="SearchButton" Content="Search" Width="90" Height="38" Margin="0,0,0,10"/>
                <TextBlock x:Name="HistoricalWarningTextBlock"
                           Text="Warning: Historical searches may take a longer time to run."
                           Foreground="#FFF1EC5C" TextWrapping="Wrap" TextAlignment="Center"
                           Width="250"
                           Visibility="{Binding IsChecked, ElementName=HistoricalCheckBox, Converter={StaticResource BoolToVis}}"/>
            </StackPanel>
        </StackPanel>
    </ScrollViewer>
</Window>

"@

## Sanitize/prep the XAML and read it
$inputXML = $inputXML -replace 'mc:Ignorable="d"','' -replace "x:N",'N' -replace '^<Win.*', '<Window'
[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
[xml]$XAML = $inputXML

$Reader = (New-Object System.Xml.XmlNodeReader $xaml)
$Form = [Windows.Markup.XamlReader]::Load( $reader )

## Load and declare the XAML elements as variables to manipulate later
$XAML.SelectNodes("//*[@Name]") | % {
    Set-Variable -Name "GUI$($_.Name)" -Value $Form.FindName($_.Name) -ErrorAction Stop -Scope Global
}

## Search button has been clicked, begin the search
$GUISearchButton.Add_Click({

## If the historical check box isn't checked, only search for currently posted jobs
if ($GUIHistoricalCheckBox.IsChecked -eq $False) {

## Grab the information required to build the search request
$APIKey = $GUIAPIKeyTextBox.Text
$Email = $GUIEmailAddressTextBox.Text
$Location = $GUILocationTextBox.Text
$JobSeries = $GUIJobSeriesTextBox.Text
$Remote = $GUIRemoteJobCheckBox.IsChecked

## Set the required headers for the API Request
$Headers = @{
    'Host' = 'data.usajobs.gov'
    'User-Agent' = $Email
    'Authorization-Key' = $APIKey
}
$Request = Invoke-RestMethod "$($USAJobsSearchAPI)JobCategoryCode=$JobSeries&LocationName=$Location&RemoteIndicator=$Remote" -Headers $Headers
$ResultCount = $Request.SearchResult.SearchResultCount

$Results = for ($i=0; $i -lt $ResultCount; $i++) {     
    $Result = $Request.SearchResult.SearchResultItems[$i]
    @{ "Result$i" = $Result}
}

$Output = $Results | Where ({$_.Values.MatchedObjectDescriptor.PositionLocationDisplay -notmatch 'Negotiable'}) | Where-Object ({$_.Values.MatchedObjectDescriptor.PositionLocationDisplay -notmatch 'Domestic'}) | % {

If ($_.Values.MatchedObjectDescriptor.UserArea.Details.OtherInformation -match 'LQA') {
    $LQA = $True }
Else {
    $LQA = $False }

$MinGrade = $_.Values.MatchedObjectDescriptor.UserArea.Details.LowGrade
$MaxGrade = $_.Values.MatchedObjectDescriptor.UserArea.Details.HighGrade

If ($MinGrade -eq $MaxGrade) {
    $Grade = $MinGrade }
Else {
    $Grade = "$MinGrade-$MaxGrade" }

$Properties = [ordered]@{

        'Location' = $_.Values.MatchedObjectDescriptor.PositionLocationDisplay
        'Organization' = $_.Values.MatchedObjectDescriptor.OrganizationName
        'Title' = $_.Values.MatchedObjectDescriptor.PositionTitle
        'LQA' = $LQA
        'MinPay' = $_.Values.MatchedObjectDescriptor.PositionRemuneration.MinimumRange
        'MaxPay' = $_.Values.MatchedObjectDescriptor.PositionRemuneration.MaximumRange
        'OpenDate' = $_.Values.MatchedObjectDescriptor.PositionStartDate.Split('T')[0]
        'CloseDate' = $_.Values.MatchedObjectDescriptor.ApplicationCloseDate.Split('T')[0]
        'URL' = $_.Values.MatchedObjectDescriptor.PositionURI
        'Grade' = $Grade
        }
    New-Object -TypeName psobject -Property $Properties
    }
$Output | Out-GridView }

## Else the checkbox is checked, so search historically instead
Elseif ($GUIHistoricalCheckBox.IsChecked -eq $True) {

## Grab the information required to build the search request
$Location = $GUILocationTextBox.Text
$JobSeries = $GUIJobSeriesTextBox.Text
$Remote = $GUIRemoteJobCheckBox.IsChecked
$FromDate = ($GUIFromDatePicker.SelectedDate).ToString("MM-dd-yyyy")
$ToDate = ($GUIToDatePicker.SelectedDate).ToString("MM-dd-yyyy")

## Submit the API request with supplied parameters, such as the date range
$InitialRequest = Invoke-RestMethod "$($USAJobsHistoricSearchAPI)PositionSeries=$JobSeries&LocationName=$Location&PositionOpenDate=$FromDate&EndPositionOpenDate=$ToDate"

## Create an empty array to store the results in
[System.Collections.ArrayList]$OutputArray = @{}

## Get total amount of pages returned from request, submit new request for each if required
$TotalPages = $InitialRequest.Paging.metadata.totalPages
    for ($i = 1; $i -le $TotalPages; $i++) {
        $RequestURL = "https://data.usajobs.gov/api/historicjoa?PositionSeries=2210&StartPositionOpenDate=01-01-2022&EndPositionOpenDate=03-29-2023&pagesize=1000&pagenumber=$i"
        $Request = Invoke-RestMethod $RequestURL
        If ($Remote -eq $True) {
            $Output = $Request.data | Where { ($_.PositionLocations -match $Location) -and ($_.TeleworkEligible -eq 'Y') } }
        Elseif ($Remote -eq $False) {
            $Output = $Request.Data | Where { ($_.PositionLocations -match $Location) -and ($_.TeleworkEligible -eq 'N') } }

$Output | % {
    $Object = [PSCustomObject]@{
        'Country' = $_.positionLocations.PositionLocationCountry
        'City' = $_.positionLocations.PositionLocationCity
        'Agency' = $_.hiringAgencyName
        'Title' = $_.positionTitle
        'MinPay' = $_.minimumSalary
        'MaxPay' = $_.maximumSalary
        'OpenDate' = $_.positionOpenDate.ToString('MM/dd/yyy')
        'CloseDate' = $_.positionCloseDate.ToString('MM/dd/yyy')
        'URL' = "https://www.usajobs.gov/job/$($_.USAJobsControlNumber)" }
        $OutputArray.Add($Object) }
        }
$OutputArray | Out-GridView }
})

$Form.ShowDialog()
