import sqlite3
import os

def update_event_pictures():
    # Get the path to the database file
    db_path = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), 
                          'assets', 'database', 'EventsDatabase.db')
    
    # Connect to the database
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()
    
    # Dictionary of category to picture URL mappings
    category_pictures = {
        'Art': 'https://images.stockcake.com/public/b/e/5/be562590-972b-497a-a013-44d18c4e7e21_large/art-gallery-interior-stockcake.jpg',
        'Business': 'https://image.benq.com/is/image/benqco/five-reasons-you-need-wireless-screen-mirroring-for-an-effective-business-meeting%201200x700?$ResponsivePreset$',
        'Education': 'https://www.kennedy-center.org/globalassets/education/networks-conferences--research/conferences--events/partners-in-education-annual-meeting/partners-annual-meeting-169.jpg?width=1600&quality=70',
        'Food': 'https://www.meetingsnet.com/sites/meetingsnet.com/files/styles/article_featured_retina/public/menuplanning.jpg?itok=paUEbxgK',
        'Music': 'https://www.queensu.ca/gazette/sites/gazettewww/files/assets/CONVO%20-%20music%20festival%20Glastonbury%20james-genchi-APJ6MvCZefM-unsplash.jpg',
        'Sports': 'https://sportsfest.com/wp-content/uploads/slider/cache/1cc4172424ad1fbdc2a3c1e748639386/SportsFest-Highlights-06.jpg',
        'Technology': 'https://evessio.s3.amazonaws.com/customer/b4289942-d924-4d3d-9044-2b4131d4ae91/event/c80bc84d-48e8-4e21-ad98-e1f07cd04705/media/eb29de31-node_24174241-node_emap_Techfest_Day_Conference_Nov_23-187_Large_Large.jpeg'
    }
    
    try:
        # Update pictures for each category
        for category, picture_url in category_pictures.items():
            cursor.execute('''
                UPDATE Event 
                SET Picture = ? 
                WHERE Category = ?
            ''', (picture_url, category))
            
            print(f"Updated picture for category: {category}")
        
        # Commit the changes
        conn.commit()
        print("All updates completed successfully!")
        
    except sqlite3.Error as e:
        print(f"Database error: {e}")
    except Exception as e:
        print(f"Error: {e}")
    finally:
        # Close the connection
        conn.close()

if __name__ == "__main__":
    update_event_pictures() 