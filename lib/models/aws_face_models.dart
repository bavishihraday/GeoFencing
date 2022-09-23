class FaceActionResult {
  late List<dynamic> json;

  List<MatchedFace> matchedFaces = [];

  FaceActionResult(this.json) {
    // Add all matches, mostly useful for the findFace call
    for (var element in json) {
      matchedFaces.add(
        MatchedFace(
          similarity: element["Similarity"],
          confidence: element["Face"]["Confidence"],
          // Above are always present, while below are only present in findFace call
          faceId: element["Face"].containsKey("FaceId") ? element["Face"]["FaceId"] : null,
          imageId: element["Face"].containsKey("ImageId") ? element["Face"]["ImageId"] : null,
          fileName: element["Face"].containsKey("ExternalImageId") ? element["Face"]["ExternalImageId"] : null
        )
      );

      // Sort faces from greatest to least according to their similarity,
      // This is so that one could just get the matchedFaces[0] for the most
      // likely match
      matchedFaces.sort((a, b) => a.similarity.compareTo(b.similarity));
      matchedFaces = matchedFaces.reversed.toList();
    }
  }
}

// Container so that you can sort by similarity for example, and for easy re-use
class MatchedFace {
  late double similarity;
  late double confidence;
  late String? faceId;
  late String? imageId;
  late String? fileName;

  MatchedFace({ required this.similarity, required this.confidence, this.faceId, this.imageId, this.fileName });
}