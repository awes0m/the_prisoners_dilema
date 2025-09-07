@echo off
echo Building Flutter web app for GitHub Pages...
flutter build web --release --base-href="/tpdgame/" --output=docs
echo.
echo Build complete! Committing changes...
git add docs/
git commit -m "Update web build for GitHub Pages"
git push origin main
echo.
echo Deployment complete! Your app should be available at:
echo https://awes0m.github.io/tpdgame/
pause