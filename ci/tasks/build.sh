#!/bin/sh

inputDir=  outputDir=  versionFile=  artifactId=  packaging=  archiveType=  archiveIncludeFile=

while [ $# -gt 0 ]; do
  case $1 in
    -i | --input-dir )
      inputDir=$2
      shift
      ;;
    -o | --output-dir )
      outputDir=$2
      shift
      ;;
    -v | --version-file )
      versionFile=$2
      shift
      ;;
    -a | --artifactId )
      artifactId=$2
      shift
      ;;
    -p | --packaging )
      packaging=$2
      shift
      ;;
    -at | --archiveType )
      archiveType=$2
      shift
      ;;
    -f | --archiveIncludeFile )
      archiveIncludeFile="${archiveIncludeFile} |/$2"
      shift
      ;;
    * )
      echo "Unrecognized option: $1" 1>&2
      exit 1
      ;;
  esac
  shift
done

error_and_exit() {
  echo $1 >&2
  exit 1
}

if [ ! -d "$inputDir" ]; then
  error_and_exit "missing input directory: $inputDir"
fi
if [ ! -d "$outputDir" ]; then
  error_and_exit "missing output directory: $outputDir"
fi
if [ ! -f "$versionFile" ]; then
  error_and_exit "missing version file: $versionFile"
fi
if [ -z "$artifactId" ]; then
  error_and_exit "missing artifactId!"
fi
if [ -z "$packaging" ]; then
  error_and_exit "missing packaging!"
fi
if [ -z "$archiveType" ]; then
  error_and_exit "missing archiveType!"
fi

version=`cat $versionFile`
artifactName="${artifactId}-${version}.${packaging}"
revisionName="${artifactId}-${version}.${archiveType}"
files=`echo $archiveIncludeFile | sed s/\|/${inputDir}/g`
echo $files

cd $inputDir
./mvnw clean package -Pci -DversionNumber=$version

# Create an archive bundle for CodeDeploy & Put to concourse output folder
cd ..
tar zcvf $outputDir/$revisionName $inputDir/target/$artifactName $files
