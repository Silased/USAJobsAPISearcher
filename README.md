

# USAJobsAPISearcher
Simple PowerShell script that uses a WPF GUI to search USAJobs utilizing their API. Allows you to search current jobs and historical.
I created this primarily to view the frequency of which certain locations would post specific series of jobs historically.
It currently displays the results using Out-GridView, but may look into better/prettier output options.

Currently implemented Search Criteria options:
 - Remote/Telework
 - Job Series
 - Location

Additionally, the output shows you the following:
- Exact location
- Organization
- Position Title
- LQA eligibility
- Grade Range
- Min-Max Pay
- Start and end dates of the posting
- URL to the posting

A USAJobs API Key is NOT required for searching currently posted job openings.

A USAJobs API Key IS required for searching historically posted job openings.

You may request an API key at https://developer.usajobs.gov/APIRequest/

You can find the Job Series codes at https://www.usajobs.gov/help/how-to/search/filters/series/
