//

#import <UIKit/UIKit.h>
//#import "SXReplyEntity.h"
//#import "SXSimilarNewsEntity.h"

@interface SXNewsDetailBottomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *sectionHeaderLbl;

//@property(nonatomic,strong)SXReplyEntity *replyModel;
//
//@property(nonatomic,strong)SXSimilarNewsEntity *sameNewsEntity;

@property(nonatomic,assign)BOOL iSCloseing;

+ (instancetype)theShareCell;

+ (instancetype)theSectionHeaderCell;

+ (instancetype)theSectionBottomCell;

+ (instancetype)theHotReplyCellWithTableView:(UITableView *)tableView;

+ (instancetype)theContactNewsCell;

+ (instancetype)theCloseCell;

+ (instancetype)theKeywordCell;

@end
