class EndPoints {
  static const String baseUrl = "https://maxliss.evyx.lol/api/v2/";
  //! Login
  static const String expertLogin = "${baseUrl}expert/login";
  //! Login Verify Otp
  static const String expertLoginVerifyOtp = "${baseUrl}expert/login/check-otp";
  //! Logout
  static const String expertLogout = "${baseUrl}expert/logout";
  //! Set Location
  static const String expertSetLocation = "${baseUrl}expert/update/lon-lat";
  //! Community
  static const String expertCommunity = "${baseUrl}expert/community";
  //! Community Details
  String experCommunityDetails(int id) {
    return "${baseUrl}expert/community/$id";
  }

  //! Create Community
  static const String expertCreateCommunity = "${baseUrl}expert/community";
  //! Update Community
  String expertUpdateCommunity(int id) {
    return "${baseUrl}expert/community/$id";
  }

  //! Delete Community
  String experDeleteCommunity(int id) {
    return "${baseUrl}expert/community/$id";
  }

  //! Like Community
  static const String expertLikeCommunity = "${baseUrl}expert/community/likes";

  //! Profile
  static const String expertProfile = "${baseUrl}expert/profile";

  //! Bookings
  static const String expertBookingByDate =
      "${baseUrl}expert/booking-expert/slots";

  //! Requests
  static const String getExpertRequests =
      "${baseUrl}expert/booking-expert/expert";
}

class ApiKey {
  static const String authorization = "Authorization";
  static const String token = "token";
  static const String result = "result";
  static const String id = "id";
  static const String user = "user";
  static const String expert = "expert";
  static const String name = "name";
  static const String email = "email";
  static const String password = "password";
  static const String image = "image";
  static const String phone = "phone";
  static const String city = "city";
  static const String state = "state";
  static const String lat = "lat";
  static const String lon = "lon";
  static const String price = "price";
  static const String experience = "experience";
  static const String rating = "rating";
  static const String createdAt = "created_at";
  static const String updatedAt = "updated_at";
  static const String slots = "slots";
  static const String day = "day";
  static const String start = "start";
  static const String end = "end";
  static const String location = "location";
  static const String likes = "likes";
  static const String time = "time";
  static const String images = "images";
  static const String title = "title";
  static const String message = "message";
  static const String data = "data";
  static const String otp = "otp";
  static const String oldImages = "old_images";
  static const String method = "_method";
  static const String put = "PUT";
  static const String communityId = "community_id";
  static const String isWishlist = "is_wishlist";
  static const String posts = "posts";
  static const String ratingCount = "rating_count";
  static const String date = "date";
  static const String question = "question";
  static const String answer = "answer";
  static const String orderId = "order_id";
  static const String answerAndQuestion = "answer&question";
  static const String status = "status";
  static const String expertSlot = "expert_slot";
}
