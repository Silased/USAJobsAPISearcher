# USAJobsAPISearcher
Simple PowerShell script that uses a WPF GUI to search USAJobs utilizing their API. Allows you to search current jobs and historical.
I created this primarily to view the frequency of which certain locations would post jobs historically.
It currently displays the results just using Out-GridView, but may look into better output options.

You do not need an API Key for the historical postings, but to search current posting you do.
You can filter for Telework/remote jobs by using the "Remote" checkbox.

You may request an API key at https://developer.usajobs.gov/APIRequest/ 

You can find Job Series codes at https://www.usajobs.gov/help/how-to/search/filters/series/
