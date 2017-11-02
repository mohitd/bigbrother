# Big Brother
Multi-Camera Person Tracking

Algorithm

1. Identify ROI and compute covariance matrix
2. Start mean-shift tracking in initial camera
3. Compute mean-shift prediction in initial camera 
4. Update covariance matrix
5. Use camera homography to transform coordinates in initial position to all other cameras
6. Search around the transformed position in all other cameras
7. Go to 3

# Contributors
- Mohit Deshpande <<deshpande.75@osu.edu>>
- Brad Pershon <<pershon.1@osu.edu>>
