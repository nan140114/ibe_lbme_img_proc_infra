# You have to run this script with an owner user
ENVIRONMENT=dev
PROJECT_ID=dev-ibe-lbme-img-proc

gcloud config set project $PROJECT_ID

gcloud services enable storage.googleapis.com
gcloud services enable pubsub.googleapis.com
gcloud services enable apigateway.googleapis.com 
gcloud services enable datastore.googleapis.com
gcloud services enable run.googleapis.com
gcloud services enable containerregistry.googleapis.com
gcloud services enable iam.googleapis.com
gcloud services enable compute.googleapis.com

gsutil mb -p $PROJECT_ID gs://$ENVIRONMENT-statefiles-$PROJECT_ID

gcloud iam service-accounts create $ENVIRONMENT-iac-tf-sa --display-name="SA to deploy IAC" --project $PROJECT_ID

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$ENVIRONMENT-iac-tf-sa@$PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/apigateway.admin"

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$ENVIRONMENT-iac-tf-sa@$PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/storage.admin"

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$ENVIRONMENT-iac-tf-sa@$PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/run.admin"

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$ENVIRONMENT-iac-tf-sa@$PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/pubsub.admin"

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$ENVIRONMENT-iac-tf-sa@$PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/compute.admin"