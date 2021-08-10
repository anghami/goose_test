
# Service template

### Description
This contains common helm charts templates for anghami services, and a generic Jenkinsfile for CI/CD pipelines.

### Usage

1. Importing the templates:
	- If you are starting from scratch, you can use the github template feature and create a repo by clicking on the 'Use this template' button above.
	- If you are importing into an existing project, copy this project files into your project, preferably in a separate branch than master.
2. Run `bash template.sh {your_app_name} {builder_type}`: 
	- Builder type can be one of: `python`, `go`, `nodejs`.
	- This will commit (without pushing) your app name and builder replacements.
	- You can delete this script from your project after this step.
3. Run `jx import --no-draft` from the `jx` namespace. You might need AWS credentials/MFA for this step.
4. Push your changes. If you are importing into an existing project, it's preferable to create a pull request of your changes for them to be reviewed and merged.

NB: If the project's main branch name is 'main' instead of 'master', you have to replace 'master' with 'main' in the Jenkinsfile.
