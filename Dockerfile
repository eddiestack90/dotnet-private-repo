FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build-env
WORKDIR /app
EXPOSE 80
EXPOSE 443
EXPOSE 5000
EXPOSE 8080
# Copy csproj and restore as distinct layers
COPY *.csproj ./
RUN dotnet restore

# Copy everything else and build
COPY . ./
RUN dotnet build
RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1
WORKDIR /app
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "TodoApi.dll"]