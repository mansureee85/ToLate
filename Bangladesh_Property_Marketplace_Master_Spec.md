
# Bangladesh House Rent & Property Marketplace
## Master Development Specification for Antigravity

**Document Type:** Master Product Requirements + Technical Architecture + Implementation Instructions  
**Platforms:** Web, Android, iOS, Admin Web Panel  
**Primary Market:** Bangladesh  
**Project Status:** Build a production-ready application  
**Primary Rule:** Preserve existing code and configuration; do not introduce dummy or preloaded business data.

---

# 1. MASTER INSTRUCTIONS FOR ANTIGRAVITY

You are acting as a senior software architect, Flutter engineer, web engineer, backend engineer, database designer, UI/UX designer, QA engineer, and security engineer.

Your task is to inspect the existing repository and build a complete Bangladesh-focused House Rent & Property Marketplace.

The platform must allow people to search for rental homes, rooms, flats, land, houses, offices, shops, and other commercial properties. Owners, landlords, property sellers, and authorized agents must be able to create listings. Users must be able to search, filter, save, compare, contact, review, report, and request viewings for properties.

The complete product includes:

1. Customer-facing Web Application.
2. Android Application.
3. iOS Application.
4. Secure Admin Web Panel.
5. Backend APIs and business logic.
6. Authentication and authorization.
7. Property, building, and unit management.
8. Search and location management.
9. Photo and video uploads.
10. Voice-to-text for suitable text fields.
11. Reviews and review verification.
12. Moderation, fraud reporting, and verification.
13. Notifications, messaging, and viewing requests.
14. Analytics and reports based only on real data.
15. Automated tests and deployment documentation.

## 1.1 Non-negotiable development rules

- Inspect the repository before changing anything.
- Identify the existing framework, architecture, dependencies, database, authentication, and implemented features.
- Preserve all working functionality.
- Do not delete, rewrite, or replace existing code unnecessarily.
- Do not overwrite configuration files without reviewing them.
- Do not create a new project inside an existing project unless genuinely required.
- Reuse existing components and services when suitable.
- Do not create fake users, sample listings, fake reviews, invented locations, fake ratings, fake statistics, or mock business data in production.
- Do not use hard-coded dummy JSON as a production fallback.
- Do not claim a feature is complete if it is only a UI mockup.
- Do not show success messages unless the operation actually succeeds.
- Do not expose secrets, service credentials, private documents, NID numbers, or private user information.
- Do not use public Admin registration.
- Do not trust client-side authorization for sensitive actions.
- Keep source files small, modular, readable, and testable.
- Use clear naming and consistent coding conventions.
- Every meaningful form must include validation, loading, success, error, and retry states.
- Every "Other" option must provide a custom text input where applicable.
- Do not invent missing business requirements. Document assumptions.
- Do not disable security rules to make a feature work.
- Do not hard-code private API keys into client applications.
- Do not represent OTP verification as proof of property ownership.
- Do not represent a map pin as proof of legal ownership.
- Do not claim a listing is completely fraud-proof.
- Do not display invented verification badges or ratings.
- Do not use fake counts to make the application look populated.

## 1.2 Required implementation workflow

Follow this sequence:

1. Inspect the repository.
2. Prepare a requirement-to-file implementation plan.
3. Identify missing requirements and architectural risks.
4. Implement shared foundations.
5. Implement authentication and user profiles.
6. Implement property, building, and unit models.
7. Implement search and location management.
8. Implement listing creation and media uploads.
9. Implement social features, reviews, messaging, and inquiries.
10. Implement verification and moderation.
11. Implement the Admin Panel.
12. Implement responsive Web, Android, and iOS behavior.
13. Add tests and security rules.
14. Run available tests, analysis, and builds.
15. Fix discovered issues.
16. Report the completed work, modified files, remaining tasks, configuration requirements, and test results.

Work incrementally. After each major feature, check for regressions before moving forward.

---

# 2. PRODUCT VISION

Build a trusted property marketplace for Bangladesh where tenants, buyers, landlords, sellers, and authorized agents can discover and advertise properties.

The platform should make property discovery easier by offering:

- Search based on property type and purpose.
- Administrative location selection.
- Budget and property-specific filters.
- Live matching against real listings.
- Photos and optional property walkthrough videos.
- Building profiles with multiple floors and units.
- Transparent verification indicators.
- Owner and agent profiles.
- Property comparisons.
- Favorites and saved searches.
- Viewing appointments.
- Inquiries and messaging.
- Reviews from eligible tenants.
- Community interaction and reporting.
- A comprehensive Admin Panel.

The interface should be modern, responsive, accessible, and easy to use on low-end Android phones as well as desktop browsers.

## 2.1 Supported property purposes

- Rent.
- Sale.
- Sublet.
- Room rental.
- Shared accommodation.
- Residential land purchase or sale.
- Agricultural land purchase or sale.
- Commercial land purchase or sale.
- House purchase or sale.
- Flat purchase or sale.
- Office rental or sale.
- Shop rental or sale.
- Commercial building rental or sale.
- Other approved property categories.

Any "Other" category must provide a text field for the user to specify the category.

## 2.2 User roles

A user may hold multiple roles where the business rules permit.

- Tenant.
- Property buyer.
- Property owner.
- Landlord.
- Property seller.
- Authorized property agent.

Administrative roles are managed separately.

## 2.3 Administrative roles

- Super Admin.
- Listing Moderator.
- Verification Officer.
- Content Moderator.
- Customer Support Agent.
- Finance Administrator.
- Analyst / Read-only Administrator.

Apply least-privilege access. A moderator must not automatically receive Super Admin permissions.

---

# 3. RECOMMENDED TECHNOLOGY AND ARCHITECTURE

First inspect the repository and retain the existing stack when it is viable. The following is a recommended architecture, not permission to replace working infrastructure without justification.

## 3.1 Frontend

- Flutter for Android and iOS.
- Flutter Web if the existing web application uses Flutter or a shared Flutter implementation is appropriate.
- If the existing web application uses React, Next.js, or another established web framework, preserve it when reasonable.
- Responsive web layouts for desktop, tablet, and mobile.
- Shared design tokens, validation rules, and API contracts across platforms wherever practical.

## 3.2 Backend

Potential services, depending on the existing project:

- Firebase Authentication or an equivalent secure identity provider.
- Cloud Firestore or an appropriately designed relational database.
- Cloud Storage or equivalent secure media storage.
- Server-side functions or a backend API.
- A search service when database queries are insufficient.
- A supported maps and geocoding provider.
- An email/SMS provider where required.

Do not assume that every service is already configured. Inspect the repository and document missing configuration.

## 3.3 Architecture principles

- Feature-first organization.
- Separation of UI, domain, and data layers.
- Repository pattern.
- Dependency injection where useful.
- Reusable form controls and media components.
- Centralized error handling.
- Server-side validation.
- Server-side authorization.
- Environment-specific configuration.
- Automated tests.
- No business logic embedded in large UI widgets.

---

# 4. MODULAR CODE STRUCTURE

Adapt this structure to the actual project. Do not duplicate an existing architecture merely to match this example.

A recommended Flutter structure:

```text
lib/
  main.dart

  app/
    app.dart
    app_router.dart
    app_theme.dart
    app_config.dart
    app_bootstrap.dart

  core/
    constants/
    errors/
    extensions/
    logging/
    network/
    permissions/
    security/
    services/
    utils/
    validation/
    widgets/

  data/
    models/
    repositories/
    datasources/
    serializers/

  features/
    auth/
      data/
      domain/
      presentation/

    profile/
      data/
      domain/
      presentation/

    home_feed/
      data/
      domain/
      presentation/

    search/
      data/
      domain/
      presentation/

    locations/
      data/
      domain/
      presentation/

    buildings/
      data/
      domain/
      presentation/

    properties/
      data/
      domain/
      presentation/

    media/
      data/
      domain/
      presentation/

    favorites/
      data/
      domain/
      presentation/

    saved_searches/
      data/
      domain/
      presentation/

    reviews/
      data/
      domain/
      presentation/

    comments/
      data/
      domain/
      presentation/

    messaging/
      data/
      domain/
      presentation/

    inquiries/
      data/
      domain/
      presentation/

    viewings/
      data/
      domain/
      presentation/

    notifications/
      data/
      domain/
      presentation/

    verification/
      data/
      domain/
      presentation/

    reports/
      data/
      domain/
      presentation/

    support/
      data/
      domain/
      presentation/

    admin/
      data/
      domain/
      presentation/

  platform/
    android/
    ios/
    web/

  l10n/
```

## 4.1 File-size and modularity rules

Prefer small files with one clear responsibility.

Examples:

- `property_listing.dart`: listing model.
- `property_repository.dart`: repository contract.
- `property_repository_impl.dart`: data implementation.
- `property_card.dart`: reusable listing card.
- `property_card_media.dart`: listing media section.
- `property_price.dart`: price presentation.
- `property_location_label.dart`: location presentation.
- `property_filter_state.dart`: filter state.
- `property_filter_sheet.dart`: filter interface.
- `property_search_controller.dart`: search coordination.

Avoid giant files containing multiple screens, models, repositories, and business rules.

A file may be larger when its responsibility genuinely requires it, but prioritize maintainability rather than an arbitrary line-count limit.

## 4.2 Required platform adapters

Implement platform-specific adapters for:

- Camera.
- Gallery and file picker.
- Image cropping.
- Video selection and playback.
- Speech recognition.
- Location permissions.
- Push notifications.
- Sharing.
- Deep links.
- File downloads.
- Platform-specific media processing.

Web must not attempt to call unsupported native APIs directly.

Android and iOS permissions must be configured correctly and requested only when needed.

---

# 5. DESIGN SYSTEM AND NAVIGATION

## 5.1 Design requirements

Create a professional, trustworthy property marketplace interface.

Use:

- Consistent spacing and typography.
- Clear price presentation in BDT.
- Reusable cards.
- Accessible contrast.
- Responsive layouts.
- Proper empty states.
- Skeleton loading states.
- Error messages with recovery actions.
- Confirmation dialogs for destructive actions.
- Keyboard and screen-reader accessibility.
- Touch-friendly controls.

Avoid clutter, unnecessary animations, and deceptive urgency indicators.

Do not invent user counts, listing counts, review counts, or activity notifications.

## 5.2 Customer navigation

Mobile primary navigation:

1. Home.
2. Search.
3. Post Property.
4. Saved.
5. Profile.

Desktop navigation may use a header, sidebar, or responsive combination.

Home Feed and personal Profile are different screens. Do not merge them.

## 5.3 Feed behavior

Home Feed should show only real listings returned by the backend.

Possible feed categories:

- Latest.
- Nearby.
- Recommended.

Show a category only when its underlying data and ranking logic are implemented. Nearby requires a usable location or a selected search area. Recommended must be based on an explainable, real ranking method.

When no listings exist, show an honest empty state and allow the user to start a search or create a listing.

---

# 6. AUTHENTICATION AND ACCOUNT MANAGEMENT

## Screen 1: Splash and Bootstrap

Responsibilities:

- Load app configuration.
- Initialize supported services.
- Check authentication state.
- Check required app version.
- Load permitted user profile information.
- Route to the correct destination.

Do not block the whole application indefinitely when an optional service fails.

## Screen 2: Welcome and Onboarding

Explain the primary features:

- Find a property.
- Advertise a property.
- Compare options.
- Contact owners or agents.
- Review eligible rental experiences.

Provide Skip and Continue options where appropriate.

## Screen 3: Sign Up and Login

Support Bangladesh phone authentication using a configured provider.

Optional Google or email authentication may be offered only when configured and tested.

Fields and actions:

- Country code.
- Phone number.
- Send OTP.
- Resend OTP with cooldown.
- Terms and privacy acceptance.
- Switch between login and account creation.

Do not create an authenticated user based only on client-side form validation.

## Screen 4: OTP Verification

Include:

- Six-digit OTP input where supported by the provider.
- Auto-fill when supported.
- Resend countdown.
- Invalid-code message.
- Expired-code handling.
- Rate limiting.
- Retry controls.

Never log OTP values.

OTP verification confirms control of a phone number; it does not prove legal identity or property ownership.

## Screen 5: Basic Profile Setup

Fields:

- Full name.
- Profile photo, optional initially.
- Cover photo, optional initially.
- Preferred language.
- Preferred contact method.
- Account role selection.
- Consent and privacy settings.

Validate required fields without collecting unnecessary sensitive data.

## Screen 6: User Roles

Allow users to choose relevant roles:

- Tenant.
- Buyer.
- Owner / Landlord.
- Seller.
- Agent.

Explain any additional requirements for agents or professional advertisers.

Role selection does not automatically grant legal authority to advertise a property.

## Screen 7: Terms, Privacy, and Consent

Provide accessible legal documents and consent controls.

Support versioning of terms and record the accepted version and timestamp.

Obtain separate consent where necessary for optional location, communication, or verification processes.

---

# 7. USER PROFILE AND PROFILE MEDIA

## Screen 8: User Profile

Display public information permitted by the user's privacy settings:

- Profile photo.
- Cover photo.
- Display name.
- Public biography.
- Public role labels.
- Published listings.
- Public verification indicators.
- Reviews and ratings, where applicable.
- Joined date, if appropriate.
- Contact or inquiry actions based on privacy settings.

Do not expose private email addresses, NID information, verification documents, or private residential addresses.

## Screen 9: Edit Profile

Fields:

- Name.
- Biography.
- Preferred contact method.
- Public role description.
- Profile picture.
- Cover photo.
- Privacy controls.

### Profile picture requirements

Users must be able to:

- Capture a picture using Camera.
- Select a picture from Gallery or file picker.
- Preview the selected picture.
- Crop and reposition the image.
- Zoom when supported.
- Replace the image.
- Remove the image.
- Retry failed uploads.
- See upload progress.
- Cancel an upload.

### Cover photo requirements

Provide the same selection options:

- Camera.
- Gallery / file picker.
- Preview.
- Crop.
- Position adjustment.
- Replace.
- Remove.
- Upload progress.
- Retry and error handling.

The profile picture and cover photo must be separate media records and independently updateable.

Web should use browser-supported camera/file selection where available. Android and iOS should use appropriate native pickers and permissions.

Do not claim an image was captured live if it was selected from a gallery.

## Screen 10: Media Picker and Cropper

Create reusable media-picker components.

Requirements:

- Image type validation.
- Configurable file-size limits.
- Image dimension validation.
- Preview before upload.
- Crop and orientation handling.
- Upload cancellation.
- Retry.
- Progress.
- Safe temporary-file handling.
- Clear permission-denied explanations.

Do not permanently store private media in public directories.

## Screen 11: Account Settings and Privacy

Settings include:

- Edit profile.
- Notification preferences.
- Contact preferences.
- Blocked users.
- Location permission.
- Privacy settings.
- Language.
- Security settings.
- Account deletion request.
- Sign out.

Deleting an account must follow an explicit retention and deletion policy. Do not silently delete financial, legal, or moderation records that must lawfully be retained.

---

# 8. LOCATION AND BANGLADESH ADMINISTRATIVE AREAS

## Screen 12: Location Selection Wizard

Use a cascading selector:

1. Division.
2. District.
3. Upazila / Thana.
4. Area / locality.
5. Optional map pin.

The administrative dataset must be imported from a reliable, maintained source or provided through an authoritative data-maintenance process.

Do not invent missing districts, upazilas, or locality names.

Support Bangla and English names or aliases when the data source provides them.

### Location data rules

- Use canonical identifiers.
- Store relationships between administrative levels.
- Normalize spelling and duplicate aliases.
- Permit search across supported aliases.
- Track data source and update time.
- Handle renamed or merged administrative areas.
- Do not silently convert an unverified typed locality into an official administrative area.

If a user enters an area that is not present, save it as a `ProposedArea` for moderation or future matching. Do not present it as an officially approved locality until accepted.

## Screen 13: Map Pin Selection

Allow a user to select an approximate property location when supported.

Requirements:

- Explain location precision.
- Support manual adjustment.
- Protect exact addresses where privacy requires it.
- Store latitude and longitude with appropriate access controls.
- Avoid exposing precise coordinates for private residences unnecessarily.

A map pin confirms only the submitted location. It does not prove ownership.

## Screen 14: Nearby Places

Show nearby places only when real data is available from a configured provider or a verified internal dataset.

Potential categories:

- Schools.
- Hospitals.
- Public transport.
- Markets.
- Universities.
- Offices.
- Parks.
- Other configured categories.

Display data provenance where appropriate. Do not fabricate distances, facilities, or nearby places.

---

# 9. SEARCH WIZARD

## Screen 15: Search Wizard Start

Start with a simple question:

"What type of property are you looking for?"

Offer:

- Flat for rent.
- House for rent.
- Room for rent.
- Sublet.
- Flat for sale.
- House for sale.
- Land for sale.
- Office for rent.
- Shop for rent.
- Commercial property.
- Other.

Then ask the user's purpose:

- Rent.
- Buy.
- Sell.
- Sublet.

Only show relevant options for the chosen purpose.

## Screen 16: Location Questions

Allow the user to select:

- Division.
- District.
- Upazila / Thana.
- Area.
- Optional nearby landmark.
- Optional map radius.

Allow skipping optional location detail.

## Screen 17: Budget Questions

For rental searches:

- Minimum monthly rent.
- Maximum monthly rent.
- Advance amount range, if relevant.
- Service charge preference, if relevant.

For sales:

- Minimum price.
- Maximum price.

Use BDT formatting.

Validate that minimum values do not exceed maximum values.

## Screen 18: Dynamic Property Questions

Questions depend on the selected property category.

### Residential property

- Bedrooms.
- Bathrooms.
- Drawing room, if applicable.
- Dining room, if applicable.
- Kitchen.
- Balcony.
- Size.
- Size unit.
- Floor.
- Total floors.
- Furnishing.
- Parking.
- Lift.
- Generator.
- Security.
- Water supply.
- Gas or alternative cooking arrangements.
- Availability date.
- Family, bachelor, or other occupancy preference where lawful and appropriate.

### Land

- Land type.
- Land area.
- Area unit.
- Road access.
- Road width, if known.
- Utility availability, if known.
- Intended use.
- Location.
- Ownership documentation status, if voluntarily declared and relevant.

Supported land units may include:

- Decimal.
- Katha.
- Bigha.
- Acre.
- Square feet.
- Other, with a custom unit field.

Do not silently convert between local units using an assumed universal conversion. Use an explicitly configured conversion table and clearly show the conversion standard.

### Office and shop

- Commercial category.
- Floor.
- Floor area.
- Entrance/access.
- Parking.
- Lift.
- Washroom.
- Power backup.
- Frontage, if relevant.
- Availability.
- Rent or sale price.

### Other category

Provide a free-text description.

Every relevant "Other" selection must reveal a text field. Do not force users to choose an inaccurate predefined value.

## Screen 19: Live Matching and Search Summary

As the user answers questions:

- Update the search criteria.
- Query real backend data.
- Display a truthful matching count when available.
- Allow editing any answer.
- Show a final summary.
- Provide a Search button.

Debounce frequent changes and avoid excessive backend requests.

If no matches exist:

- Explain that no current listings match.
- Offer to widen the budget.
- Offer to change the location.
- Offer to remove optional filters.
- Offer to save the search and receive alerts.

Never create fake matches.

## Screen 20: Search Results

Provide:

- List view.
- Grid view on suitable larger screens.
- Sort by newest.
- Sort by price.
- Relevant filters.
- Map view.
- Save search.
- Favorite action.
- Compare action.

Only show sorting options supported by real query logic.

## Screen 21: Map Search

Plot only returned listings with valid coordinates and appropriate visibility permissions.

Requirements:

- Cluster nearby pins.
- Handle large result sets.
- Load results by viewport.
- Synchronize map and result list.
- Do not disclose protected coordinates.
- Provide a list alternative for accessibility.

## Screen 22: Search Filters

Include applicable filters:

- Property purpose.
- Property type.
- Location.
- Budget.
- Size.
- Bedrooms.
- Bathrooms.
- Floor.
- Furnishing.
- Parking.
- Lift.
- Availability.
- Verification status.
- Photos available.
- Video available.
- Owner or authorized agent.
- Other category-specific criteria.

Do not display filters that have no meaningful implementation.

## Screen 23: Compare Properties

Allow users to compare selected listings.

Comparison fields should depend on category.

Residential comparison:

- Price.
- Location.
- Size.
- Bedrooms.
- Bathrooms.
- Floor.
- Furnishing.
- Parking.
- Lift.
- Available facilities.
- Verification indicators.
- Listing update date.

Land comparison:

- Price.
- Land area.
- Area unit.
- Location.
- Road access.
- Declared facilities.
- Verification indicators.

Do not treat a verification badge as a guarantee of title or transaction safety.

---

# 10. HOME FEED AND SOCIAL FEATURES

## Screen 24: Home Feed

Display real published listings.

Each listing card may contain:

- Cover photo.
- Optional video indicator.
- Title.
- Price.
- Location.
- Property type.
- Relevant property specifications.
- Owner or agent display name.
- Verification indicators.
- Favorite button.
- Like button.
- Comment count.
- Share action.
- Report action.
- Contact or view-details action.

Counts must come from actual backend records.

## Screen 25: Listing Comments

Allow permitted users to:

- Write comments.
- Edit their own comments within configured rules.
- Delete their own comments where allowed.
- Reply to comments.
- Report abusive comments.
- Block a user.
- View moderation status where appropriate.

Apply rate limits and spam controls.

A comment is not a tenant review and must never be presented as one.

## Screen 26: Share Listing

Provide:

- Platform share sheet.
- Copy link.
- Share to supported applications.
- Web deep link.
- App deep link where configured.

Shared links must respect listing publication and privacy rules.

If a listing becomes private, expired, or removed, the link must show an appropriate status rather than exposing private information.

## Screen 27: Favorites

Allow users to:

- Save a listing.
- Remove a listing.
- View saved properties.
- Open a listing.
- Receive status changes where supported.

A removed listing should show an understandable unavailable state when retained references are appropriate.

## Screen 28: Saved Searches and Alerts

Users can save a search containing:

- Property type.
- Purpose.
- Location.
- Budget.
- Other filters.
- Notification preference.

Allow users to:

- Rename a saved search.
- Edit criteria.
- Enable or disable alerts.
- Delete a saved search.

Generate alerts only from real matching listings. Prevent duplicate notifications.

## Screen 29: Recently Viewed and Activity

Show actual user activity where useful.

Possible items:

- Recently viewed listings.
- Saved properties.
- Recent inquiries.
- Viewing requests.
- User-owned listings.

Do not fabricate browsing history.

---

# 11. PROPERTY DETAILS

## Screen 30: Property Details

Display:

- Listing title.
- Price.
- Rent frequency or sale price.
- Advance or deposit, where applicable.
- Service charges.
- Property description.
- Photos.
- Optional walkthrough video.
- Property category.
- Building details.
- Unit details.
- Size and unit.
- Floor and total floors.
- Facilities.
- Location.
- Approximate map location, if allowed.
- Availability.
- Owner/agent profile.
- Verification indicators and scope.
- Listing published/updated date.
- Reviews where relevant.
- Contact owner.
- Send inquiry.
- Request viewing.
- Save.
- Compare.
- Share.
- Report.

Only show information actually supplied or verified. Do not invent facilities, ownership status, or legal-document checks.

## Screen 31: Photo Gallery

Provide:

- Full-screen viewer.
- Swipe navigation.
- Zoom where supported.
- Thumbnail navigation.
- Loading and failed-image states.
- Appropriate image caching.
- Accessible descriptions where practical.

Do not treat an image selected from a gallery as live-captured evidence.

## Screen 32: Property Video Player

Property listing videos are optional.

Allow owners or authorized agents to upload a property walkthrough video.

Requirements:

- Supported video formats.
- Configurable maximum file size.
- Configurable maximum duration.
- Upload progress.
- Retry.
- Processing state.
- Thumbnail generation.
- Transcoding where required.
- Playback compatibility.
- Network-aware loading.
- No autoplay with sound.
- Pause and replay controls.
- Moderation.
- Removal and replacement.

Use a configured media-processing service where necessary. Do not assume all video formats can play on every platform.

### Critical distinction

- Property listings may include photos and optional video.
- Tenant reviews may include photos only.
- Tenant reviews must not accept video uploads.

Enforce this rule in the UI, backend validation, and storage policy.

## Screen 33: Contact Owner / Inquiry

Provide configurable contact options:

- In-app message.
- Inquiry form.
- Phone contact, if the owner permits it.
- Other supported contact method.

Collect only necessary information.

Include:

- Inquiry message.
- Preferred contact method.
- Optional viewing interest.
- Consent where needed.

Prevent abuse through rate limits, blocking, and reporting.

Do not expose a private phone number unless the owner has explicitly chosen to make it available.

## Screen 34: Request Property Viewing

Allow users to request a viewing.

Fields:

- Preferred date.
- Preferred time.
- Optional alternative time.
- Message.
- Preferred contact method.

Status flow:

- Requested.
- Accepted.
- Alternative Proposed.
- Declined.
- Cancelled.
- Completed.
- No-show.

Both parties should receive appropriate notifications.

Prevent unauthorized users from changing another user's viewing request.

## Screen 35: Inquiries Dashboard

For owners and authorized agents, display:

- New inquiries.
- In-progress inquiries.
- Responded inquiries.
- Closed inquiries.
- Related listing.
- Message history.
- Relevant timestamps.

Allow filtering and searching.

Do not expose another advertiser's private inquiries.

## Screen 36: Viewing Requests Dashboard

Display incoming and outgoing viewing requests.

Support:

- Date filtering.
- Status filtering.
- Accept/decline.
- Propose an alternative.
- Cancel.
- Mark completed.
- Report abuse.

Record status changes in an auditable way.

---

# 12. PROPERTY LISTING CREATION

## Screen 37: Start Listing

Entry point for property owners and authorized agents.

Explain:

- Required information.
- Photo and video rules.
- Verification limitations.
- Publication review.
- Listing expiration and renewal policies.

Offer Save Draft.

## Screen 38: Owner / Agent Authorization

Ask the advertiser to identify their relationship to the property:

- Owner.
- Landlord.
- Authorized agent.
- Other permitted representative.

Collect only information necessary for the workflow.

For agents, implement an authorization review process where required.

Do not imply that selecting "Owner" proves ownership.

## Screen 39: Listing Location

Collect:

- Division.
- District.
- Upazila / Thana.
- Area.
- Address or landmark, subject to privacy policy.
- Optional map pin.
- Location visibility preference.

Use canonical location IDs where available.

## Screen 40: Building Profile

A building may contain multiple floors and multiple independent units.

Building-level information may include:

- Building name, optional.
- Building type.
- Address.
- Administrative location.
- Number of floors.
- Lift.
- Parking.
- Generator.
- Security.
- Water supply.
- Shared facilities.
- Building photos.
- Optional building walkthrough video.

Do not require a building name for a standalone house or land listing.

## Screen 41: Single Flat or Multiple Units

Support:

- One unit in a building.
- Multiple flats on the same floor.
- Multiple units across different floors.
- Separate listings for independent units.
- Building-level shared facilities.
- Unit-level overrides.

Example:

A building has five floors and three units per floor. The advertiser should be able to enter shared building information once, then create or configure individual units.

The interface may provide:

- Add floor.
- Add unit.
- Duplicate unit configuration.
- Apply shared fields to selected units.
- Override an individual unit's data.
- Preview all units.
- Publish selected eligible units.

Each unit must have:

- A unique identifier.
- Its own price where applicable.
- Its own availability status.
- Its own photos/videos where applicable.
- Its own specifications.
- Its own publication status.

Do not make every unit share the same availability state automatically.

A building profile is not the same as an individual property listing.

## Screen 42: Price, Advance, and Costs

Fields depend on purpose and category.

Rental:

- Monthly rent.
- Advance or deposit.
- Service charge.
- Utility arrangement.
- Other recurring costs.
- Negotiable flag.
- Available-from date.

Sale:

- Asking price.
- Negotiable flag.
- Relevant additional costs, if declared.

Other cost:

- Custom label.
- Amount.
- Frequency.
- Optional description.

Display currencies and units consistently.

Never invent costs or silently assume that a charge is included.

## Screen 43: Dynamic Property Details

Use the same category-specific questions described in the Search Wizard, but adapted for advertisers.

Validate numerical values and units.

Allow a custom description for relevant "Other" options.

Distinguish:

- User-provided information.
- System-calculated information.
- Independently verified information.

Do not label user-entered information as verified.

## Screen 44: Photo and Video Upload

Provide a dedicated media workflow.

Allow multiple property photos and optional property videos within configured limits.

Features:

- Camera capture where supported.
- Gallery/file picker.
- Multi-selection.
- Preview.
- Reorder photos.
- Choose cover image.
- Remove media.
- Replace media.
- Upload progress.
- Retry failed uploads.
- Cancel upload.
- Media validation.
- Duplicate-media warnings where supported.
- Thumbnail generation.
- Video processing status.
- Network-failure recovery.

Building media and unit media must be distinguishable.

An advertiser must be able to identify which photos represent the building and which represent a particular unit.

### Media integrity rules

- Validate media on the server.
- Use secure storage paths.
- Restrict accepted content types.
- Apply file-size and duration limits.
- Strip public EXIF GPS metadata where appropriate.
- Do not expose private original files unnecessarily.
- Treat similarity detection as a warning, not proof of fraud.
- Do not claim gallery images were captured live.
- Provide a clear moderation and removal process.

## Screen 45: Voice-Assisted Listing Details

Every suitable text input must support a microphone-based voice-to-text option where the platform and speech service support it.

Examples:

- Listing title.
- Property description.
- Landmark.
- Facilities description.
- Contact message.
- Review text.
- Comment.
- Support message.
- Other/custom text fields.

Voice-to-text must not be mandatory.

The user must be able to type instead.

### Voice-to-text behavior

- Show a microphone control beside suitable fields.
- Request microphone/speech permission only when needed.
- Start and stop dictation explicitly.
- Show recording/listening state.
- Insert recognized words into the text field.
- Allow the user to edit the transcript.
- Allow the user to delete incorrect text.
- Do not submit automatically.
- Handle permission denial gracefully.
- Handle unsupported languages.
- Handle speech-service failures.
- Do not permanently store raw audio unless explicitly required and separately consented to.
- Explain when speech processing is handled by an external provider.

Support Bangla, English, and mixed-language input where the configured speech service supports it.

Do not promise perfect recognition.

For price, phone number, size, floor, and other structured values, require explicit confirmation when speech recognition may have misinterpreted the value.

## Screen 46: Contact and Availability

Fields:

- Preferred contact method.
- Phone visibility preference.
- Available viewing times.
- Availability date.
- Optional contact instructions.

Avoid collecting unnecessary private information.

## Screen 47: Preview and Generated Advertisement

Show a complete preview before submission.

The system may generate a title or description from the user's actual answers.

Generated text must:

- Use only provided information.
- Avoid inventing facilities.
- Avoid claiming legal ownership verification without evidence.
- Avoid guaranteeing returns or property quality.
- Be editable.
- Clearly flag uncertain or missing details.
- Respect moderation rules.

Provide:

- Back to edit.
- Save Draft.
- Submit for Review.

## Screen 48: My Listings and Drafts

List the advertiser's own listings.

Statuses:

- Draft.
- Pending Review.
- Changes Requested.
- Published.
- Rejected.
- Paused.
- Expired.
- Rented.
- Sold.
- Archived.

Actions depend on status and permission:

- Edit.
- Preview.
- Submit.
- Pause.
- Resume.
- Mark rented.
- Mark sold.
- Renew.
- Archive.
- Delete where permitted.

Every status transition must be validated by the backend.

## Screen 49: Listing Performance

Show only genuine metrics.

Potential metrics:

- Detail-page views.
- Unique views where reliably calculated.
- Favorites.
- Inquiries.
- Viewing requests.
- Time period.
- Listing status.

Document metric definitions.

Exclude internal bots and obvious automated traffic where possible.

Do not fabricate performance figures.

---

# 13. REVIEWS AND REPUTATION

## Screen 50: Reviews Overview

Separate these concepts:

- Property review.
- Landlord/owner review.
- Area or neighborhood review.

Show actual rating aggregates and counts.

Indicate whether a review is verified or unverified based on the actual verification process.

Do not combine unrelated ratings into a misleading score.

## Screen 51: Write Tenant Review

A review form may include:

- Overall rating.
- Communication rating.
- Accuracy of listing information.
- Property condition.
- Move-in/move-out experience.
- Written review.
- Optional photos.
- Rental duration.
- Would rent again.
- Optional move-out reason.
- Other reason with a custom text field.

Use only relevant questions.

### Review media rule

A tenant review may contain photos but MUST NOT contain video.

Enforce this at every layer:

1. Do not offer video selection in the review UI.
2. Restrict review media models to approved image types.
3. Validate MIME type and actual file content on the server.
4. Reject video upload requests.
5. Apply appropriate storage rules.
6. Test attempts to bypass client-side validation.

Do not reuse a generic property-media uploader if it permits videos.

### Voice-to-text for reviews

Provide an optional microphone button for the written review field.

The transcript must remain editable.

Typing must remain available.

The user must review and submit the final text manually.

### Review eligibility

Where possible, allow one review per eligible tenancy or clearly defined rental relationship.

Prevent duplicate reviews using server-side rules.

If no reliable evidence of a tenancy exists, label the review according to the actual verification status rather than falsely presenting it as verified.

## Screen 52: Review Verification

Potential evidence may include:

- A completed in-app rental workflow.
- A documented, consented tenancy verification process.
- A verified booking or viewing followed by an eligible rental process.
- Other evidence approved by the platform's legal and privacy policies.

A phone OTP or account age alone is insufficient.

Keep private supporting evidence separate from public review content.

Do not publish tenancy agreements, identity documents, or private addresses.

Allow eligible users to understand why a review is marked verified or unverified.

## Screen 53: Owner Reply and Review Reporting

Owners may reply to reviews within configured limits.

Owners must not be able to delete a review merely because it is negative.

Allow users to report:

- Fake experience.
- Harassment.
- Personal information exposure.
- Threats.
- Spam.
- Conflicts of interest.
- Other policy violations.

Moderators should review reports consistently and provide an appeal process where appropriate.

Do not suppress legitimate criticism simply because an advertiser disagrees with it.

---

# 14. MESSAGING, NOTIFICATIONS, AND SUPPORT

## Screen 54: Inbox and Messages

Features:

- Conversation list.
- Message history.
- Related property listing.
- Timestamps.
- Read status, if implemented.
- Send text messages.
- Optional image sharing only if approved by policy.
- Block and report.
- Retry failed messages.
- Empty and error states.

If real-time messaging is not configured, do not present a nonfunctional real-time UI.

Apply access controls so only conversation participants can read messages.

## Screen 55: Notifications

Notification types may include:

- New inquiry.
- New message.
- Viewing request.
- Viewing accepted or declined.
- Saved-search match.
- Listing approved.
- Changes requested.
- Listing rejected.
- Listing expiring.
- Review response.
- Support update.
- Security alert.

Support in-app notifications and configured push/email/SMS channels.

Do not send notifications for events that did not occur.

## Screen 56: Notification Preferences

Allow users to control supported categories and channels.

Provide:

- Push preferences.
- Email preferences.
- SMS preferences, if supported.
- Saved-search alert frequency.
- Marketing preferences.
- Quiet hours where appropriate.

Mandatory security notifications must be distinguished from optional marketing messages.

## Screen 57: Help and Support

Provide:

- Frequently asked questions.
- Contact support.
- Report a problem.
- Safety guidance.
- Account support.
- Listing support.
- Privacy requests.
- Ticket history.

Support tickets should have statuses and timestamps.

Do not claim a ticket has been resolved until it is actually resolved.

---

# 15. ADMIN WEB PANEL

The Admin Panel must be a separate, secure administrative experience.

It must not be accessible through public user registration or ordinary user role selection.

Use server-side authorization for every administrative operation.

## A1. Admin Login

Features:

- Admin authentication.
- MFA where supported.
- Session management.
- Login rate limiting.
- Suspicious login handling.
- Secure logout.

Do not create default production credentials or hard-code administrator passwords.

Initial Super Admin provisioning must follow a secure documented process.

## A2. Overview Dashboard

Display real operational metrics:

- Registered users.
- Published listings.
- Pending listing reviews.
- Reported listings.
- Pending verification cases.
- Open support tickets.
- Active viewing requests.
- Moderation queue size.

Only display metrics that are actually computed.

Include date ranges and definitions.

Show an empty state if the database has no data.

## A3. User Directory and User Detail

Authorized administrators can search users by permitted fields.

Display only the information needed for the administrator's role.

Possible actions:

- View public profile.
- View account status.
- Review relevant reports.
- Suspend or restrict an account when authorized.
- Restore an account when authorized.
- Initiate a verification review.
- Review account history.

Every sensitive action must have a reason and audit record.

Do not show passwords, OTP values, or unnecessary identity-document contents.

## A4. Listing Review Queue

Allow moderators to review pending listings.

Display:

- Listing title.
- Advertiser.
- Property type.
- Location.
- Price.
- Photos and videos.
- Listing fields.
- Report history where permitted.
- Verification state.
- Submission date.

Actions:

- Approve.
- Reject.
- Request changes.
- Flag for verification.
- Escalate.
- Pause publication when authorized.

Require a reason for rejection or requested changes.

Record the moderator, timestamp, and status transition.

## A5. Building and Unit Manager

Allow authorized staff to inspect building and unit relationships.

Verify:

- Correct building association.
- Unique unit identifiers.
- Unit-level prices.
- Unit availability.
- Duplicate or inconsistent listings.
- Shared versus overridden fields.
- Media association.

Do not accidentally publish all units when only one was approved.

## A6. Verification Center

Manage verification cases such as:

- Phone verification.
- Identity verification, if supported.
- Agent authorization.
- Listing media review.
- Property location checks.
- Property inspection.
- Document review, if legally appropriate.

Every verification record must include:

- Verification type.
- Scope.
- Status.
- Reviewer or provider.
- Timestamp.
- Expiry or recheck date where applicable.
- Evidence reference with restricted access.
- Decision reason.

Possible states:

- Not Started.
- Pending.
- In Review.
- Verified.
- Failed.
- Expired.
- Revoked.

### Verification policy

Never display a generic "Verified Property" badge without explaining what was verified.

Use precise labels, for example:

- Phone Verified.
- Advertiser Identity Checked.
- Agent Authorization Checked.
- Listing Media Reviewed.
- Property Location Checked.
- Property Inspected.

Only display labels supported by completed evidence.

A property inspection does not automatically prove ownership or legal title.

## A7. Reports and Complaints Queue

Support reports about:

- Suspected fraud.
- Incorrect price.
- Incorrect location.
- Duplicate listing.
- Rented or sold property still advertised.
- Stolen photos.
- Harassment.
- Spam.
- Misleading claims.
- Privacy violations.
- Copyright complaints.
- Other.

Workflow:

- Open.
- Assign.
- Investigate.
- Request more information.
- Take action.
- Resolve.
- Close.

Keep a history of actions.

Do not automatically ban an account based solely on an unreviewed report.

## A8. Review and Comment Moderation

Moderators can review reported content.

Actions:

- Keep content.
- Remove content under policy.
- Restrict content visibility.
- Request edits where supported.
- Warn a user.
- Escalate.
- Record appeal outcome.

Preserve legitimate criticism and avoid arbitrary review manipulation.

## A9. Location and Area Manager

Features:

- Import authoritative administrative data.
- Manage canonical divisions, districts, and upazilas.
- Review proposed areas.
- Merge duplicate aliases.
- Approve or reject proposed locality names.
- Track data source and updates.
- Review location inconsistencies.

Do not allow an ordinary user to modify canonical administrative records directly.

## A10. Category and Dynamic Question Builder

Allow authorized administrators to manage configured categories and their questions.

Question types may include:

- Text.
- Number.
- Boolean.
- Single select.
- Multi-select.
- Date.
- Measurement with unit.
- Optional custom "Other" value.

Each question should define:

- Identifier.
- Label.
- Applicable category.
- Required/optional status.
- Validation.
- Options.
- Unit configuration.
- Visibility rules.
- Version.
- Active status.

Do not delete a field from existing listings without a migration or backward-compatibility plan.

## A11. Media Moderation

Review reported or flagged images and videos.

Support:

- Media preview.
- Associated listing.
- Upload metadata needed for moderation.
- Policy flags.
- Duplicate-media warning.
- Removal decision.
- Evidence and audit history.

Do not expose private original media unnecessarily.

Review videos separately from images where different rules apply.

## A12. Review Verification Queue

Manage review verification requests.

Actions:

- Approve verification.
- Decline verification.
- Request additional evidence.
- Mark evidence insufficient.
- Revoke an incorrect verification.
- Record reasons.

Only authorized officers should access sensitive evidence.

Review verification must not expose private tenancy documents to public users.

## A13. Customer Support Desk

Support staff can:

- Search support tickets.
- Assign tickets.
- Respond.
- Add internal notes.
- Escalate cases.
- Set status.
- Close tickets.

Internal notes must never accidentally appear in public messages.

## A14. Notifications and Announcements

Allow authorized staff to create announcements where supported.

Requirements:

- Audience selection.
- Preview.
- Scheduling, if implemented.
- Publication confirmation.
- Cancellation.
- Delivery status where available.
- Audit trail.

Do not send bulk notifications by default without explicit authorization.

## A15. Analytics and Exports

Provide genuine reports for:

- Listings by status.
- Listings by property category.
- Inquiries.
- Moderation workload.
- Verification cases.
- Support tickets.
- Search usage.
- User activity, subject to privacy policy.

Exports must enforce role permissions and minimize personal data.

Record export events where appropriate.

Do not create fake charts or fabricated analytics.

## A16. Pricing, Promotion, and Payments

Prepare for future monetization if required:

- Featured listings.
- Paid promotion.
- Subscription plans.
- Payment records.
- Refunds.
- Invoices.

Do not display a functional payment flow until a real payment provider, backend verification, and reconciliation process are configured.

Never trust a client-supplied payment-success flag.

## A17. App Configuration

Authorized administrators may manage supported configuration:

- Theme options.
- Splash-screen assets.
- Category visibility.
- Listing media limits.
- Video limits.
- Feature flags.
- Legal document versions.
- Notification templates.
- Maintenance messages.

Validate changes and keep an audit trail.

Do not allow configuration changes that expose secrets or disable mandatory security.

## A18. Admin Users, Permissions, and Audit Log

Features:

- Create administrative accounts through a secure authorized process.
- Assign role-based permissions.
- Suspend administrative access.
- Review action history.
- Review sensitive exports.
- Track listing approvals and removals.
- Track verification decisions.

Do not permit administrators to grant themselves arbitrary privileges unless an explicitly authorized Super Admin workflow permits it.

Protect audit records against unauthorized modification.

## A19. Security and System Health

Show operational information where supported:

- Backend health.
- Failed jobs.
- Media-processing failures.
- Notification failures.
- Error rates.
- Storage usage.
- Suspicious activity indicators.
- Authentication provider status.

Never display secret keys or sensitive infrastructure credentials in the panel.

---

# 16. DATA MODEL REQUIREMENTS

Adapt field types and relations to the chosen database. The following are logical entities, not a mandate to create an unmaintainable collection structure.

## 16.1 User

Fields may include:

- id.
- authentication provider identifier.
- display name.
- profile photo reference.
- cover photo reference.
- biography.
- preferred language.
- public roles.
- account status.
- privacy settings.
- created timestamp.
- updated timestamp.

Never store plaintext passwords or OTP values.

## 16.2 UserRole

- user ID.
- role.
- status.
- approval metadata where required.

Agent authorization must be distinct from simply selecting the Agent role.

## 16.3 UserProfileMedia

- id.
- user ID.
- media purpose: profile or cover.
- storage reference.
- media type.
- moderation state where applicable.
- created timestamp.

Profile and cover media must be independently replaceable.

## 16.4 Building

- id.
- owner or responsible advertiser ID.
- location reference.
- building type.
- number of floors.
- shared facilities.
- building media references.
- verification references.
- created timestamp.
- updated timestamp.

## 16.5 PropertyUnit

- id.
- building ID, optional when not part of a building.
- unit identifier.
- floor.
- property category.
- size and unit.
- bedroom/bathroom counts where relevant.
- unit-specific facilities.
- availability.
- unit media references.
- created timestamp.
- updated timestamp.

## 16.6 PropertyListing

- id.
- advertiser ID.
- building ID, optional.
- property unit ID, optional.
- purpose.
- category.
- title.
- description.
- price.
- price frequency.
- advance/deposit.
- additional costs.
- location reference.
- coordinates subject to access policy.
- dynamic property attributes.
- status.
- availability date.
- published timestamp.
- expiration timestamp.
- created timestamp.
- updated timestamp.

Separate listing status from verification status.

## 16.7 ListingMedia

- id.
- listing ID or unit/building association.
- media type.
- storage reference.
- thumbnail reference.
- order index.
- processing status.
- moderation status.
- uploaded by.
- created timestamp.

Validate the actual media content on the server.

## 16.8 Administrative Location Entities

Suggested entities:

- Division.
- District.
- UpazilaOrThana.
- CanonicalArea.
- ProposedArea.
- LocationAlias.

Include canonical IDs, parent references, source metadata, and update history.

## 16.9 Favorite

- id.
- user ID.
- listing ID.
- created timestamp.

Enforce the appropriate uniqueness rule to avoid duplicate favorites.

## 16.10 SavedSearch

- id.
- user ID.
- search criteria.
- alert settings.
- last matched cursor or timestamp.
- created timestamp.
- updated timestamp.

## 16.11 Inquiry

- id.
- listing ID.
- requester ID.
- advertiser ID.
- message.
- status.
- created timestamp.
- updated timestamp.

## 16.12 Conversation and Message

Conversation:

- id.
- participant IDs.
- related listing ID, optional.
- created timestamp.
- updated timestamp.

Message:

- id.
- conversation ID.
- sender ID.
- message content.
- permitted media references, if enabled.
- created timestamp.
- moderation state, where applicable.

Only participants and authorized services may access conversation content.

## 16.13 ViewingRequest

- id.
- listing ID.
- requester ID.
- advertiser ID.
- preferred date/time.
- proposed alternative.
- status.
- status history.
- created timestamp.
- updated timestamp.

## 16.14 Like and Comment

Like:

- id.
- user ID.
- listing ID.
- created timestamp.

Comment:

- id.
- listing ID.
- author ID.
- parent comment ID, optional.
- content.
- status.
- created timestamp.
- updated timestamp.

## 16.15 TenantReview

- id.
- author ID.
- property/listing reference.
- reviewed party reference, where applicable.
- rating fields.
- review text.
- rental duration, if supplied.
- eligibility reference.
- verification status.
- moderation status.
- created timestamp.
- updated timestamp.

## 16.16 ReviewMedia

- id.
- review ID.
- image storage reference.
- moderation status.
- created timestamp.

This entity must accept images only. It must not support video media.

## 16.17 ReviewVerification

- id.
- review ID.
- verification method.
- status.
- evidence reference.
- reviewer or service reference.
- decision reason.
- created timestamp.
- updated timestamp.

Keep evidence private.

## 16.18 Report

- id.
- reporter ID.
- reported entity type.
- reported entity ID.
- reason.
- description.
- status.
- assigned moderator.
- resolution.
- created timestamp.
- updated timestamp.

## 16.19 VerificationRecord

- id.
- subject type.
- subject ID.
- verification type.
- status.
- scope.
- evidence references.
- reviewer/provider.
- verified timestamp.
- expiry or recheck timestamp.
- decision reason.

## 16.20 ModerationCase

- id.
- related entity.
- report references.
- assigned moderator.
- status.
- actions taken.
- appeal status.
- timestamps.

## 16.21 Notification

- id.
- recipient ID.
- notification type.
- related entity reference.
- read status.
- created timestamp.

## 16.22 SupportTicket

- id.
- user ID.
- category.
- description.
- attachments where allowed.
- status.
- assigned support agent.
- messages.
- created timestamp.
- updated timestamp.

## 16.23 AdminUser

- id.
- identity-provider reference.
- administrative role.
- permission set.
- account status.
- created timestamp.

## 16.24 AuditLog

- id.
- actor ID.
- actor role.
- action.
- entity type.
- entity ID.
- reason.
- timestamp.
- relevant safe metadata.

Do not put passwords, OTP values, private documents, or full sensitive payloads into audit logs.

## 16.25 AppConfiguration

- id/key.
- value.
- version.
- updated by.
- updated timestamp.

Validate configuration server-side.

## 16.26 PropertyCategory and DynamicQuestionDefinition

Use structured category configuration rather than scattered hard-coded conditions.

Preserve old listing data when question definitions evolve.

## 16.27 PaymentRecord

Create this entity only if a real payment integration is planned or implemented.

Possible fields:

- id.
- user ID.
- transaction reference.
- provider reference.
- amount.
- currency.
- status.
- verified server timestamp.
- refund state.

Do not treat client-side payment callbacks as authoritative.

---

# 17. BACKEND, DATABASE, AND SECURITY RULES

Security is mandatory, not an optional future enhancement.

## 17.1 Authentication

- Validate authentication tokens server-side.
- Apply rate limits.
- Protect account recovery.
- Handle expired sessions.
- Prevent unauthorized account switching.
- Secure administrative authentication.

## 17.2 Authorization

- Users may edit only their own permitted profile fields.
- Advertisers may edit only their own permitted listings.
- Agents must satisfy the relevant authorization rules.
- Public users may read only published public listing fields.
- Draft and pending listings must remain private.
- Review evidence must remain private.
- Administrative actions require explicit role permissions.
- Admin access must be checked by the backend.

## 17.3 Trusted server operations

The client must not directly control:

- Verification decisions.
- Administrative roles.
- Payment success.
- Moderation outcomes.
- Authoritative rating aggregates.
- Sensitive audit logs.
- Other users' private data.
- Protected status transitions.

Use trusted server-side functions or APIs for these operations.

## 17.4 File and media security

- Validate file signatures where possible.
- Validate content types.
- Enforce size and duration limits.
- Use appropriate storage permissions.
- Restrict private evidence.
- Reject videos in review media.
- Prevent unauthorized media association.
- Remove orphaned uploads when safe.
- Apply moderation and malware scanning where supported.

## 17.5 Data integrity

- Use server-generated timestamps for authoritative events.
- Validate numeric ranges.
- Enforce referential integrity where supported.
- Prevent duplicate operations.
- Use idempotency for retryable operations.
- Handle concurrent edits.
- Keep status transitions auditable.

## 17.6 Rate limits and abuse prevention

Apply appropriate limits to:

- OTP requests.
- Login attempts.
- Listing creation.
- Comments.
- Reviews.
- Messages.
- Reports.
- Media uploads.
- Saved-search notifications.

Use configurable limits rather than arbitrary unreviewed hard-coded values.

---

# 18. FRAUD PREVENTION AND TRUST

No single technique can guarantee that every property listing is genuine.

Implement layered safeguards.

## 18.1 Verification distinctions

Separate:

- Phone verification.
- Identity verification.
- Agent authorization.
- Media review.
- Location review.
- Property inspection.
- Legal ownership/title verification, only when a suitable independent process actually exists.

Never collapse these into a universal verified status.

## 18.2 Media authenticity

Possible supporting signals:

- Similarity checks.
- Duplicate-image detection.
- Metadata inspection.
- User-submitted live capture.
- Consented inspection.
- Moderator review.

These signals are not conclusive proof by themselves.

Do not claim a gallery image is live-captured.

## 18.3 Listing freshness

Allow advertisers to confirm continued availability.

Potential policies:

- Reminder before expiry.
- Mark rented or sold.
- Pause stale listings.
- Expire listings after a configured period.
- Ask advertisers to reconfirm availability.

Apply status changes consistently.

## 18.4 Ownership and authorization

Require advertisers to accept responsibility for the accuracy of their claims.

Provide reporting and review workflows for suspected unauthorized listings.

Where document checks are offered, protect the documents and clearly state the scope of the check.

Do not provide a false legal guarantee.

## 18.5 Fraud reporting

Allow users to report:

- Requests for suspicious advance payments.
- Fake properties.
- Misleading photos.
- False ownership claims.
- Duplicate advertisements.
- Stolen media.
- Misleading prices.
- Unavailable properties.
- Impersonation.
- Other abuse.

Provide clear safety advice and escalation options.

---

# 19. EMPTY STATES AND NO-DUMMY-DATA POLICY

This requirement applies across every platform and environment.

## 19.1 Production must not contain fake business data

Do not prepopulate production with:

- Sample users.
- Fake owners.
- Fake agents.
- Fake properties.
- Fake ratings.
- Fake reviews.
- Fake likes.
- Fake comments.
- Fake inquiries.
- Fake appointments.
- Fake analytics.
- Fake verification badges.
- Fake nearby places.
- Fake user activity.

Do not use static sample listings when the backend is empty.

## 19.2 Allowed configuration data

Real product configuration is allowed, such as:

- Supported property categories.
- Field definitions.
- App settings.
- Official administrative location data.
- Valid translation resources.
- Legal documents.

These are configuration or reference data, not fake marketplace activity.

## 19.3 Development fixtures

Test fixtures may be used in isolated automated tests or explicitly separated development environments.

They must:

- Never be deployed into production unintentionally.
- Never be presented as real marketplace activity.
- Never silently replace failed production queries.

Document fixture loading and environment safeguards.

## 19.4 Correct empty states

If there are no listings, show:

"No properties are available for these criteria yet."

If there are no reviews, show:

"No reviews yet."

If there are no inquiries, show:

"You have no inquiries yet."

If there are no analytics records, show an appropriate empty state.

Never display invented counts such as "1,250 properties available" unless the number is calculated from real data.

---

# 20. PRIVACY AND LEGAL REQUIREMENTS

Design for data minimization and responsible handling of personal information.

Before production launch, obtain appropriate legal review for Bangladesh-specific requirements covering:

- Privacy and personal data.
- Property advertisements.
- Identity verification.
- Tenancy and review processes.
- Consumer protection.
- Electronic communications.
- Payment processing, if introduced.
- Media rights and copyright.
- Retention and deletion.
- Complaints and appeals.

Do not claim legal compliance merely because a privacy page exists.

## 20.1 Sensitive information

Do not publicly display:

- NID numbers.
- Verification documents.
- Private residential addresses.
- Private phone numbers.
- Private email addresses.
- Tenancy agreements.
- Internal moderation notes.
- Private messages.

## 20.2 Media consent

Users must have the appropriate rights to upload property photos, videos, profile pictures, cover photos, and review photos.

Provide reporting and removal workflows for privacy violations and unauthorized content.

## 20.3 Account deletion

Provide a clear account-deletion request workflow.

Explain any necessary retention and the distinction between removing public content and retaining records where legally justified.

## 20.4 Location privacy

Do not expose precise coordinates or private addresses by default when doing so could endanger a user.

Provide suitable location precision controls.

---

# 21. PERFORMANCE AND RELIABILITY

The application must work acceptably on slower networks and lower-end Android devices.

Implement:

- Pagination.
- Lazy image loading.
- Image resizing and thumbnails.
- Efficient video delivery.
- Search debouncing.
- Appropriate caching.
- Upload retries.
- Offline and network-error states.
- Loading indicators.
- Cancellation of obsolete requests.
- Query optimization.
- Background processing where supported.
- Duplicate-submission prevention.

Do not load every listing, every comment, or every media file into memory at once.

Use configurable upload limits.

Handle large image/video files without freezing the UI.

Do not lose form content unnecessarily when an upload fails.

---

# 22. ACCESSIBILITY AND LANGUAGE

Provide a consistent and accessible experience.

Support English throughout the application.

Bangla localization may be added through structured localization resources. Do not scatter literal translations across business logic.

Requirements:

- Screen-reader labels.
- Adequate contrast.
- Keyboard navigation on Web.
- Visible focus states.
- Scalable text.
- Accessible form errors.
- Accessible buttons.
- Touch-friendly controls.
- Language-aware number and date formatting.

Voice-to-text language support depends on the configured speech service. Explain unsupported languages gracefully.

---

# 23. TESTING REQUIREMENTS

Do not declare the project production-ready merely because it builds.

## 23.1 Unit tests

Test:

- Form validation.
- Price and unit conversion.
- Search criteria.
- Listing status transitions.
- Role permissions.
- Review eligibility.
- Review-media type restrictions.
- Building/unit relationships.
- Notification rules.
- Data parsing.
- Error handling.

## 23.2 Integration tests

Test:

- Registration and login.
- OTP flow using the configured test environment.
- Profile image upload.
- Cover image upload.
- Listing creation.
- Listing editing.
- Building and unit creation.
- Photo uploads.
- Video uploads for listings.
- Video rejection for reviews.
- Search.
- Favorites.
- Inquiries.
- Viewing requests.
- Reviews.
- Reporting.
- Admin moderation.
- Account deletion requests.

## 23.3 Security tests

Verify:

- A user cannot edit another user's profile.
- A user cannot modify another user's listing.
- A public user cannot access drafts.
- A user cannot grant themselves Admin permissions.
- A moderator cannot perform unauthorized Super Admin actions.
- A client cannot forge verification status.
- A client cannot forge payment success.
- Review videos are rejected by the backend.
- Private verification documents cannot be accessed publicly.
- Conversation messages are visible only to authorized participants.
- Unauthorized storage paths are inaccessible.

## 23.4 Platform tests

### Android

Test:

- Camera and gallery permissions.
- Image cropping.
- Video selection and playback.
- Voice-to-text.
- Background upload behavior.
- Low-memory handling.
- Navigation.
- Responsive layouts across screen sizes.

### iOS

Test:

- Camera and photo-library permissions.
- Image cropping.
- Video selection and playback.
- Speech permissions.
- Upload interruptions.
- App lifecycle transitions.
- Safe areas.
- Navigation.

### Web

Test:

- Responsive desktop/mobile layouts.
- File upload.
- Browser media picker.
- Browser speech support.
- Keyboard navigation.
- Browser refresh and deep links.
- Authentication redirects.
- Secure session handling.
- Upload cancellation and retries.

Do not claim platform support for an API that has not been implemented and tested.

---

# 24. ERROR HANDLING

Provide consistent errors for:

- Network unavailable.
- Authentication expired.
- Permission denied.
- Upload failed.
- Invalid media type.
- File too large.
- Video processing failed.
- Search service unavailable.
- Listing unavailable.
- Unauthorized action.
- Backend validation error.
- Rate limit reached.

Messages should explain what happened and what the user can do next.

Avoid exposing raw stack traces, secrets, or internal infrastructure details to users.

Log safe diagnostic information through an appropriate logging service.

---

# 25. IMPLEMENTATION PHASES

Antigravity should implement the application in manageable, verifiable phases.

## Phase 0: Repository Audit

- Inspect files and dependencies.
- Identify the current architecture.
- Identify existing working features.
- Identify missing features.
- Review security configuration.
- Review environment variables.
- Prepare a change plan.
- Do not delete or replace existing code.

Deliverable: repository audit and implementation plan.

## Phase 1: Foundations

- App bootstrap.
- Theme and design system.
- Navigation.
- Error handling.
- Environment configuration.
- Logging.
- Shared controls.
- API/data access foundations.

Deliverable: stable application foundation.

## Phase 2: Authentication and Profiles

- Signup/login.
- OTP.
- User roles.
- Profile editing.
- Profile picture upload.
- Cover photo upload.
- Privacy settings.
- Account deletion request.

Deliverable: working user account workflows.

## Phase 3: Location and Search

- Administrative location hierarchy.
- Location aliases.
- Proposed areas.
- Search wizard.
- Dynamic questions.
- Filters.
- Search results.
- Map search.
- Saved searches.

Deliverable: real backend-driven search.

## Phase 4: Buildings, Units, and Listings

- Building profile.
- Unit management.
- Listing creation.
- Price and costs.
- Photos.
- Optional videos.
- Voice-to-text.
- Drafts.
- Listing submission.
- Publication workflow.

Deliverable: end-to-end listing workflow.

## Phase 5: Social and Communication

- Home Feed.
- Likes.
- Comments.
- Favorites.
- Sharing.
- Messaging.
- Inquiries.
- Viewing requests.
- Notifications.

Deliverable: functional marketplace interactions.

## Phase 6: Reviews and Verification

- Review submission.
- Photo-only review media.
- Review eligibility.
- Verification records.
- Owner replies.
- Reporting.
- Moderation and appeals.

Deliverable: transparent reputation and review workflows.

## Phase 7: Admin Panel

- Secure admin login.
- Dashboard.
- User management.
- Listing moderation.
- Building/unit management.
- Verification.
- Reports.
- Review moderation.
- Location management.
- Dynamic questions.
- Support.
- Configuration.
- Audit logs.
- Security monitoring.

Deliverable: functional role-based administration.

## Phase 8: Quality and Security

- Unit tests.
- Integration tests.
- Platform tests.
- Security rules.
- Permission audits.
- Performance improvements.
- Accessibility improvements.
- Bug fixes.

Deliverable: verified implementation and test report.

## Phase 9: Release Preparation

- Production configuration.
- Environment validation.
- Android build.
- iOS build.
- Web production build.
- Deployment documentation.
- Backup and recovery guidance.
- Monitoring setup.
- Known limitations.

Deliverable: release-ready project, subject to external configuration and real deployment verification.

---

# 26. DEFINITION OF DONE

A feature is complete only when:

1. Its UI is implemented.
2. Its business logic works.
3. Its backend/data integration works.
4. Its authorization rules are implemented.
5. Its validation is implemented.
6. Loading, empty, and error states exist.
7. Its platform behavior is appropriate.
8. Relevant tests pass.
9. It does not break existing features.
10. It does not use dummy production data.
11. Documentation is updated.
12. Known limitations are reported honestly.

For media uploads, completion requires successful upload, storage security, correct associations, error handling, and testing.

For reviews, completion requires explicit rejection of video uploads by both the client and backend.

For voice-to-text, completion requires microphone controls, editable transcripts, a typing fallback, permission handling, and unsupported-platform handling.

For Admin features, completion requires server-side authorization and auditability for sensitive actions.

---

# 27. FINAL ANTIGRAVITY EXECUTION INSTRUCTIONS

Now inspect the current repository and implement this specification against the actual codebase.

Do not merely create attractive screens.

Build complete, connected workflows using real backend data.

Before each major implementation stage:

1. Review relevant existing files.
2. Identify dependencies.
3. Plan small, modular changes.
4. Preserve working functionality.
5. Implement the feature.
6. Add or update tests.
7. Run relevant checks.
8. Fix regressions.
9. Summarize the result.

If an external service is not configured, implement the appropriate adapter/interface, explain the required configuration, and do not fake a successful operation.

Do not create dummy production users, listings, reviews, locations, analytics, or verification records.

If a database is empty, show real empty states.

Do not create an Admin account with a hard-coded password. Document the secure Super Admin provisioning procedure.

Do not claim deployment, provider integration, security verification, or build success unless it has actually been performed and verified.

When complete, provide:

- Summary of implemented features.
- List of files created.
- List of files modified.
- Database schema and migrations.
- Security rules and backend functions.
- Required environment variables.
- External services requiring configuration.
- Test commands and actual results.
- Android build status.
- iOS build status.
- Web build status.
- Known limitations.
- Remaining work.
- Deployment instructions.

**Priority order:** correctness, security, data integrity, maintainability, accessibility, performance, and then visual polish.

**Final requirement:** deliver a modular, maintainable, production-oriented Bangladesh House Rent & Property Marketplace across Web, Android, iOS, and Admin Web Panel, without sacrificing existing working code or introducing fake production data.
