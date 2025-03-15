import 'package:flutter/material.dart';

class Terms extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Terms & Conditions"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TermsCard(title: "Terms of Service", content: "Welcome to Pawsome. By using our mobile application and services, you agree to comply with and be bound by these Terms of Service. If you do not agree with these terms, you should discontinue using our services immediately. Pawsome is designed to provide AI-powered pet care guidance, a pet-loving community, and adoption support. To use our services, users must be at least 13 years old. When registering for an account, users must provide accurate information and ensure their login credentials remain confidential. Users of Pawsome are expected to engage with the community respectfully and responsibly. Any form of misinformation, offensive content, fraudulent activity, or intellectual property infringement is strictly prohibited. Pawsome reserves the right to suspend or terminate accounts found violating these guidelines. While we strive to provide accurate and up-to-date information, we do not guarantee the accuracy of all content provided through our AI chatbot or community forums. Pawsome may introduce premium features in the future, which may require a subscription. Continued use of our services implies acceptance of future updates to these terms. Pawsome reserves the right to modify or discontinue any part of the service at any time without prior notice. Users will be informed of significant changes to our terms, and continued use of the application after modifications will constitute acceptance of the revised terms."),
            SizedBox(height: 10),
            TermsCard(title: "Privacy Policy", content: "At Pawsome, we prioritize user privacy and are committed to protecting personal data. We collect and store user information such as names, email addresses, phone numbers, and pet-related details to enhance the experience and provide personalized recommendations. Data collected from interactions with the AI chatbot, community posts, and search history is used to improve our services and develop more accurate pet care solutions. Pawsome does not sell or rent personal data to third parties. However, we may share information with trusted veterinary partners, NGOs, and service providers who contribute to the functionality of the app. We implement security measures such as encryption and authentication safeguards to protect user information. While we strive to maintain a secure environment, no online platform is entirely risk-free. Users are encouraged to use strong passwords and avoid sharing sensitive information within the community. Pawsome may use cookies and analytics tools to enhance performance and user experience. These can be managed through device settings. Users have the right to access, modify, or request the deletion of their personal data. Requests regarding data privacy can be made by contacting pawsome469@gmail.com. By using Pawsome, users consent to data collection and processing as outlined in this policy. We reserve the right to update our privacy policy to reflect new security measures or service enhancements. Continued use of the app after updates will signify acceptance of the revised policy."),
            SizedBox(height: 10),
            TermsCard(title: "Disclaimer", content: "Pawsome provides pet care information and AI-powered assistance to support pet owners, but this content is for informational purposes only and should not replace professional veterinary advice. While we strive to ensure accuracy, we do not guarantee that all chatbot responses, community discussions, or shared resources are medically verified. Users should always consult a licensed veterinarian for concerns regarding their pet’s health, nutrition, or well-being. Pawsome is not liable for any decisions made based on the information provided within the app. We do not assume responsibility for the actions of third-party service providers such as veterinarians, pet trainers, or animal welfare organizations featured on the platform. External links may be included within the app for additional resources, but Pawsome does not control or take responsibility for their content or policies. The platform allows users to engage with the community by sharing experiences and advice. However, Pawsome does not endorse or verify user-generated content and is not responsible for misinformation or misleading recommendations shared by community members. Users should exercise discretion when relying on community advice. Pawsome is provided as is without warranties of any kind. We are not responsible for damages, technical issues, or losses resulting from service interruptions, data inaccuracies, or external partnerships. By using the application, users acknowledge that they are responsible for their own decisions regarding pet care and community interactions. We reserve the right to update this disclaimer, and continued use of the app constitutes acceptance of any modifications."),
          ],
        ),
      ),
    );
  }
}

class TermsCard extends StatefulWidget {
  final String title;
  final String content;

  TermsCard({required this.title, required this.content});

  @override
  _TermsCardState createState() => _TermsCardState();
}

class _TermsCardState extends State<TermsCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ExpansionTile(
        title: Text(
          widget.title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(widget.content, textAlign: TextAlign.justify),
          ),
        ],
        onExpansionChanged: (expanded) {
          setState(() {
            isExpanded = expanded;
          });
        },
      ),
    );
  }
}
