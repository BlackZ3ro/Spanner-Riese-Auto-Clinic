# Editable diagram sources (draw.io)

The brief needs **working links to editable design sources**. A PNG or PDF on
its own does not count. These `.drawio` files are the editable versions of the
reference diagrams in `../`.

| File | Diagram |
|---|---|
| `usecase.drawio` | Use case: Admin left, Mechanic right, admin-only ovals, Customer |
| `seq-1-book-in-vehicle-flutter.drawio` | Mechanic books in a vehicle (Flutter, Supabase login) |
| `seq-1b-book-in-vehicle-web.drawio` | Mechanic books in a vehicle (ASP.NET web) |
| `seq-2-admin-finalize-web.drawio` | Admin finalizes a booking |
| `seq-3-admin-delete-web.drawio` | Admin deletes a booking, atomic restock |
| `seq-4-admin-reopen-web.drawio` | Admin reopens a closed booking |

## How to edit and get a share link

1. Go to <https://app.diagrams.net>, choose **Open Existing Diagram**, and pick the `.drawio` file.
2. Edit it. Every shape, line and label can be moved or retyped. The use case lines are attached to the ovals, so they follow when you drag.
3. **File > Save as > Google Drive**, then in Drive use **Share > Anyone with the link can view**. That Drive link is the "editable source link" to put in the SRS.

Once this branch is merged into `main`, anyone with access to the GitHub repo
can also open a file straight from GitHub, for example:

`https://app.diagrams.net/#HBlackZ3ro%2FSpanner-Riese-Auto-Clinic%2Fmain%2Fproject-docs%2Fphase-2%2Fdiagrams%2Feditable%2Fusecase.drawio`

The repo is **private**, so that link only works for people who have repo
access and sign in to GitHub from diagrams.net. For the marker, use the
Google Drive link.

Owners: Ofentse and Breyton (use case and sequence diagrams, U3-04). These are
the reference versions: open them, make the diagram your own, and share your
own link.
