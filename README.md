# cloud-run-cloud-deploy

This project demonstrates:
- Use github actions to trigger a build and deployment on cloud run
- deploy on a merge to `main` to a staging project, and use cloud deploy to promote the container to a prod project using a review gate
- when a pull request is opened against `main`,  or the branch with the pull request open is updated, (re)build and deploy the branch to cloud run  in a dev project and publish the preview URL to the PR comment log.  This simulates multiple developers working on feature branches simultaneously.
- use skaffold to quickly roll out the cloud run service (`skaffold run` for one command roll out, `skaffold dev` for inner dev loop)
