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

Your package will be available as a zip file called #{Name}_#{Version}.zip

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
* Create Unit Tests
* Improve da validations (Folder, commits..)