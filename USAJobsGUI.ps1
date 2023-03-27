## Load WPF
Add-Type -AssemblyName presentationframework, presentationcore
[void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void][System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")

## Define USAJobs API Search Entry Points
$USAJobsSearchAPI= "https://data.usajobs.gov/api/search?"
$USAJobsHistoricSearchAPI= "https://data.usajobs.gov/api/historicjoa?"

$inputXML = @"
    <Window x:Name="USAJobsAPISearch" x:Class="System.Windows.Window"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        mc:Ignorable="d"
        Title="USA Jobs API Searcher" Height="480" Width="550" Background="#FF313338">
    <Grid>
        <Label x:Name="TitleHeader" Content="USAJobs API Search" HorizontalAlignment="Center" VerticalAlignment="Top" Height="59" Width="320" FontSize="28" FontFamily="Cascadia Mono" Foreground="#FFF2F3F5" Margin="0,10,0,0"/>
        <Label x:Name="LocationLabel" Content="Location:" Margin="66,229,0,0" Foreground="#FFF2F3F5" FontSize="16" HorizontalAlignment="Left" VerticalAlignment="Top"/>
        <TextBox x:Name="LocationTextBox" HorizontalAlignment="Left" Margin="141,237,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="200" Height="20" Background="#FFF2F3E9" FontSize="14"></TextBox>
        <TextBlock x:Name="LocationHint" IsHitTestVisible="False" Text="Ex: Japan, California, Europe" VerticalAlignment="Top" HorizontalAlignment="Left" Margin="144,239,0,0" Foreground="DarkGray" Width="156">
            <TextBlock.Style>
                <Style TargetType="{x:Type TextBlock}">
                    <Setter Property="Visibility" Value="Collapsed"/>
                    <Style.Triggers>
                        <DataTrigger Binding="{Binding Text, ElementName=LocationTextBox}" Value="">
                            <Setter Property="Visibility" Value="Visible"/>
                        </DataTrigger>
                    </Style.Triggers>
                </Style>
            </TextBlock.Style>
        </TextBlock>
        <Label x:Name="JobSeriesLabel" Content="Job Series:" Margin="55,263,0,0" Foreground="#FFF2F3F5" FontSize="16" HorizontalAlignment="Left" VerticalAlignment="Top"/>
        <TextBox x:Name="JobSeriesTextBox" HorizontalAlignment="Left" Margin="141,271,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="200" Height="20" Background="#FFF2F3E9" FontSize="14"/>
        <TextBlock x:Name="LocationHint_Copy" IsHitTestVisible="False" Text="Ex: 2210" VerticalAlignment="Top" HorizontalAlignment="Left" Margin="144,273,0,0" Foreground="DarkGray" Width="156">
            <TextBlock.Style>
                <Style TargetType="{x:Type TextBlock}">
                    <Setter Property="Visibility" Value="Collapsed"/>
                    <Style.Triggers>
                        <DataTrigger Binding="{Binding Text, ElementName=JobSeriesTextBox}" Value="">
                            <Setter Property="Visibility" Value="Visible"/>
                        </DataTrigger>
                    </Style.Triggers>
                </Style>
            </TextBlock.Style>
        </TextBlock>
        <Label x:Name="EmailAddressLabel" Content="API Email Address:" Margin="5,105,0,0" Foreground="#FFF2F3F5" FontSize="16" HorizontalAlignment="Left" VerticalAlignment="Top"/>
        <Label x:Name="APIKeyLabel" Content="API Key:" Margin="80,141,0,0" Foreground="#FFF2F3F5" FontSize="16" RenderTransformOrigin="0.625,0.609" HorizontalAlignment="Left" VerticalAlignment="Top"/>
        <TextBox x:Name="EmailAddressTextBox" HorizontalAlignment="Left" Margin="148,111,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="200" Height="20" Background="#FFF2F3E9" FontSize="14"/>
        <TextBox x:Name="APIKeyTextBox" HorizontalAlignment="Left" Margin="148,148,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="370" Height="20" Background="#FFF2F3E9" FontSize="14"/>
        <Label x:Name="APISectionLabel" Content="API Credentials" HorizontalAlignment="Left" Margin="148,69,0,0" VerticalAlignment="Top" Background="#FF313338" Foreground="#FFF2F3E6" FontSize="18"/>
        <Label x:Name="SearchTermsLabel" Content="Search Criteria" HorizontalAlignment="Left" Margin="148,175,0,0" VerticalAlignment="Top" Background="#FF313338" Foreground="#FFF2F3E6" FontSize="18"/>
        <CheckBox x:Name="RemoteJobCheckBox" Content="?Remote" Margin="71,206,0,0" VerticalAlignment="Top" Height="20" Width="84" FlowDirection="RightToLeft" Foreground="#FFF2F3F5" FontSize="16" HorizontalAlignment="Left"/>
        <CheckBox x:Name="HistoricalCheckBox" Content="?Historical" Margin="239,206,0,0" VerticalAlignment="Top" Height="20" Width="102" FlowDirection="RightToLeft" Foreground="#FFF2F3F5" FontSize="16" HorizontalAlignment="Left"/>
        <DatePicker x:Name="FromDatePicker" HorizontalAlignment="Left" Margin="141,306,0,0" VerticalAlignment="Top" FlowDirection="LeftToRight" Width="200"/>
        <Label x:Name="FromDateLabel" Content="From Date:" Margin="52,302,0,0" Foreground="#FFF2F3F5" FontSize="16" HorizontalAlignment="Left" VerticalAlignment="Top"/>
        <DatePicker x:Name="ToDatePicker" HorizontalAlignment="Left" Margin="140,342,0,0" VerticalAlignment="Top" FlowDirection="LeftToRight" Width="200"/>
        <Label x:Name="ToDateLabel" Content="To Date:" Margin="72,337,0,0" Foreground="#FFF2F3F5" FontSize="16" HorizontalAlignment="Left" VerticalAlignment="Top"/>
        <Button x:Name="SearchButton" Content="Search" HorizontalAlignment="Left" Margin="168,395,0,0" VerticalAlignment="Top" Height="38" Width="90"/>
        <TextBlock x:Name="HistoricalWarningTextBlock" HorizontalAlignment="Left" Margin="273,395,0,0" TextWrapping="Wrap" Text="Warning: Historical searches take a longer time to run." VerticalAlignment="Top" Height="56" Width="163" Foreground="#FFF1EC5C"/>
    </Grid>
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

## Hide the date pickers by default
$GUIFromDateLabel.Visibility = "Hidden"
$GUIFromDatePicker.Visibility = "Hidden"
$GUIToDateLabel.Visibility = "Hidden"
$GUIToDatePicker.Visibility = "Hidden"
$GUIHistoricalWarningTextBlock.Visibility = "Hidden"

## Historical checkbox has been checked, show the date picker options
$GUIHistoricalCheckBox.Add_Checked({
    $GUIFromDateLabel.Visibility = "Visible"
    $GUIFromDatePicker.Visibility = "Visible"
    $GUIToDateLabel.Visibility = "Visible"
    $GUIToDatePicker.Visibility = "Visible"
    $GUIHistoricalWarningTextBlock.Visibility = "Visible"
})

## Historical checkbox has been unchecked, hide the date picker options
$GUIHistoricalCheckBox.Add_UnChecked({
    $GUIFromDateLabel.Visibility = "Hidden"
    $GUIFromDatePicker.Visibility = "Hidden"
    $GUIToDateLabel.Visibility = "Hidden"
    $GUIToDatePicker.Visibility = "Hidden"
    $GUIHistoricalWarningTextBlock.Visibility = "Hidden"
})

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
$Request = Invoke-RestMethod "https://data.usajobs.gov/api/search?JobCategoryCode=$JobSeries&LocationName=$Location&RemoteIndicator=$Remote" -Headers $Headers
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
$APIKey = $GUIAPIKeyTextBox.Text
$Email = $GUIEmailAddressTextBox.Text
$Location = $GUILocationTextBox.Text
$JobSeries = $GUIJobSeriesTextBox.Text
$Remote = $GUIRemoteJobCheckBox.IsChecked
$FromDate = ($GUIFromDatePicker.SelectedDate).ToString("MM-dd-yyyy")
$ToDate = ($GUIToDatePicker.SelectedDate).ToString("MM-dd-yyyy")

## Submit the API Request
$Request = Invoke-RestMethod "$($USAJobsHistoricSearchAPI)PositionSeries=$JobSeries&StartPositionOpenDate=$FromDate&EndPositionOpenDate=$ToDate"

If ($Remote -eq $True) {
    $Output = $Request.data | Where { ($_.PositionLocations -match $Location) -and ($_.TeleworkEligible -eq 'Y') } }

Elseif ($Remote -eq $False) {
    $Output = $Request.Data | Where { ($_.PositionLocations -match $Location) -and ($_.TeleworkEligible -eq 'N') } }

$Results = $Output | % {

$MinGrade = $_.minimumGrade
$MaxGrade = $_.maximumGrade

If ($MinGrade -eq $MaxGrade) {
    $Grade = $MinGrade }
Else {
    $Grade = "$MinGrade-$MaxGrade" }

$Properties = [ordered]@{
        'Country' = $_.positionLocations.PositionLocationCountry
        'City' = $_.positionLocations.PositionLocationCity
        'Agency' = $_.hiringAgencyName
        'Title' = $_.positionTitle
        'MinPay' = $_.minimumSalary
        'MaxPay' = $_.maximumSalary
        'OpenDate' = $_.positionOpenDate.Split('T')[0]
        'CloseDate' = $_.positionCloseDate.Split('T')[0]
        'URL' = "https://www.usajobs.gov/job/$($_.USAJobsControlNumber)"
        'Grade' = $Grade
        }
    New-Object -TypeName psobject -Property $Properties
    }
$Results | Out-GridView }
})

$Form.ShowDialog()