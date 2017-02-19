#SugarCRM Packager Creator

Create a new packge load based on github commits

* Manifest file
* New files and folders
* Zip all the content


##Setup

Select the branch you want in the project folder
Get the Commit GUID -> You can use the 
```shell
git log 
```

Set all the field

* Description
* Name
* Published Date
* Version

Done your package will be available as a zip file called #{Name}_#{Version}.zip

#TODO

##Missing parameters 

* Key
* Author
* Icon
* Type
* Readme
* acceptable_sugar_versions
* exact_matches

## Tasks
* create a list of commit than the user just pick which one he wants
* Delete the temp folder after to generate
* Delete the list_of_changes.txt
* Create Unit Tests
* Improve da validations (Folder, commits..)