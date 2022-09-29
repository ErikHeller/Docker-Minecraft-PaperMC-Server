baseURL="https://papermc.io/api/v2/projects/paper"
version=$1
if [ "$version" = "latest" ] || [ -z "$version" ]
then
  version=$(curl "$baseURL" | jq -r .versions[-1])
fi
build=$(curl "$baseURL/versions/$version" | jq -r .builds[-1])
echo "Retrieving paperMC server version $version-$build"
curl -o paper.jar "$baseURL/versions/$version/builds/$build/downloads/paper-$version-$build.jar"
chmod +x paper.jar
