# First, ask how is a web page gotten? 
# In it's simplest form, a web page is served up by a server when requested by a client
# Specifically a GET request is sent to the server, who is than responsible for providing a result

iwr cisco.com
Invoke-WebRequest cisco.com

# The key here is that it is up to the web server what to return. Depending on the server preferrences, similar requests can return different results.
# This is because the server will factor in various information into the results it returns
<#
  - IP address
  - MAC identifier
  - Browser choice
  - OS
  - HTTP or HTTPS
  - Port number used
  - Time of day/year
  - Time since last request
  - Time taken for the request / response
  - Request number
  - URL queries / parameters
  - Browser cookies
  - Browser extensions
  - Browser Window Size
  - Java Script to check if an element exists in a certain state
  - User Activity
  - The list can become quite creative...
#>

# For the above reasons, you will often notice that the results of scraped web requests will be different than how you stumble across them
# This can also pose a problem when testing fetching and parsing. One can try to save the output to an html file to make narrowing down elements easier

iwr cisco.com | ConvertTo-HTML      

# NOPE, the above won't work. IWR returns an html powershell object

$R = Invoke-WebRequest -URI https://www.bing.com?q=how+many+feet+in+a+mile
    $R.AllElements | Where-Object {
        $_.name -like "* Value" -and $_.tagName -eq "INPUT"
    } | Select-Object Name, Value

# If we want the HTML output, we can do so using the properties of the powershell object
$R = iwr -URI https://cats.com
$R.Content

# And of course we can pipe this output into a file which we can examine in a browser of our choice. Just note that this will also cause any javascript to be executed.
# This means some elements will likely be broken, and others will make calls to the server - potentially changing the scraped content when viewed. This is an art.

$R.RawContent | Out-File yourwebpage.html

# Side note: if you want to convert powershell objects into an HTML format to better view it, use ConvertTo-HTML

$R | ConvertTo-HTML | PowershellWebpageObject.htm
Get-alias | ConvertTo-HTML | Out-File aliases.htm

# Since this is powershell, it is also worth mentioning that raw HTML for parsing may not be the best. Why? well as previously mentioned, Invoke-WebRequest returns a 
# powershell object with properties and methods. These properties/methods can be used to readily extract information, though typically at the cost of overall structure
# This is useful when isolating uniquely and 100% consistently labeled elements. From experience, I can tell you that consistent labeling becomes less likely as we reach
# further nested elements. This makes sense, as these elements are used to describe more unique element groupings.

$R.links
$R.links.innerHTML
$R.inputfields.value
$R.images.src
